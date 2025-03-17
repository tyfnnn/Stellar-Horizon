//
//  FirebaseViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 13.02.25.
//

import Observation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

@MainActor
@Observable
final class FirebaseViewModel {
    private var auth = FirebaseManager.shared.auth
    private var user: FirebaseAuth.User?
    private(set) var firestoreUser: FirestoreUser?
    
    var errorMessage: String?
    
    var isUserSignedIn: Bool {
        user != nil
    }
    
    var userID: String? {
        user?.uid
    }
    
    func signInAnonymously() async {
        do {
            let result = try await auth.signInAnonymously()
            user = result.user

            firestoreUser = nil
        } catch {
            errorMessage = error.localizedDescription
            print("Error signing in anonymously: \(error.localizedDescription)")
        }
    }
    
    func isAnonymousUser() -> Bool {
        return FirebaseManager.shared.auth.currentUser?.isAnonymous ?? false
    }
    
    func signUp(
        email: String,
        password: String,
        name: String,
        birthDate: Date,
        gender: FirestoreUser.Gender
    ) async {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            user = result.user
            await createUser(
                userID: result.user.uid,
                email: email,
                name: name,
                birthDate: birthDate,
                gender: gender
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            user = result.user
            
            // Fetch the user's profile data immediately after sign-in
            let uid = result.user.uid
            
            // First check if the user profile exists
            let snapshot = try? await FirebaseManager.shared.database
                .collection("users").document(uid).getDocument()
            
            if let snapshot = snapshot, !snapshot.exists {
                // Create a new user profile if it doesn't exist
                let userProfile = FirestoreUser(
                    id: uid,
                    email: email,
                    name: email.components(separatedBy: "@").first ?? "User",
                    birthDate: Date(),
                    gender: .preferNotToSay
                )
                
                try? await FirebaseManager.shared.database
                    .collection("users").document(uid)
                    .setData(userProfile.dictionary)
            }
            
            // Then fetch user data to load it into the view model
            fetchUser(userID: uid)
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
    func getUserEmail() -> String? {
        return FirebaseManager.shared.auth.currentUser?.email
    }
    
    func signInWithGoogle() async {
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw URLError(.badServerResponse)
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: ApplicationUtility.rootViewController
            )
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw URLError(.badServerResponse)
            }
            
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )
            
            let authResult = try await auth.signIn(with: credential)
            user = authResult.user
            
            // Erstelle FireUser, falls der Benutzer neu ist
            if let isNewUser = authResult.additionalUserInfo?.isNewUser, isNewUser {
                let profile = result.user.profile
                await createUser(
                    userID: authResult.user.uid,
                    email: profile?.email ?? "",
                    name: profile?.name ?? "",
                    birthDate: Date(),
                    gender: FirestoreUser.Gender.preferNotToSay
                )
            } else {
                fetchUser(userID: authResult.user.uid)
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user = nil
            firestoreUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func createUser(
        userID: String,
        email: String,
        name: String,
        birthDate: Date,
        gender: FirestoreUser.Gender
    ) async {
        let user = FirestoreUser(
            id: userID,
            email: email,
            name: name,
            birthDate: birthDate,
            gender: gender
        )
        
        do {
            try FirebaseManager.shared.database.collection("users").document(userID).setData(from: user)
            fetchUser(userID: userID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchUser(userID: String) {
        Task {
            do {
                let snapshot = try await FirebaseManager.shared.database
                    .collection("users")
                    .document(userID)
                    .getDocument()
                self.firestoreUser = try snapshot.data(as: FirestoreUser.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // Re-authenticate the user before sensitive operations
    func reauthenticateAndDeleteAccount(password: String) async -> Bool {
        guard let currentUser = auth.currentUser, let email = currentUser.email else {
            errorMessage = "No user is currently signed in or email is missing"
            return false
        }
        
        do {
            // Create credential
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            // Reauthenticate
            try await currentUser.reauthenticate(with: credential)
            
            // If reauthentication succeeded, delete the account
            return await deleteAccount()
        } catch {
            errorMessage = "Authentication failed: \(error.localizedDescription)"
            return false
        }
    }
    
    func deleteAccount() async -> Bool {
        guard let currentUser = auth.currentUser else {
            errorMessage = "No user is currently signed in"
            return false
        }
        
        do {
            // Delete user data from Firestore
            if let userId = userID {
                // Delete user document
                try await FirebaseManager.shared.database.collection("users").document(userId).delete()
                
                // Delete user's likes
                let likesQuery = FirebaseManager.shared.database.collection("likes").whereField("user_id", isEqualTo: userId)
                let likesSnapshot = try await likesQuery.getDocuments()
                for document in likesSnapshot.documents {
                    try await document.reference.delete()
                }
                
                // Delete user's comments
                let commentsQuery = FirebaseManager.shared.database.collection("comments").whereField("user_id", isEqualTo: userId)
                let commentsSnapshot = try await commentsQuery.getDocuments()
                for document in commentsSnapshot.documents {
                    try await document.reference.delete()
                }
            }
            
            // Delete user from Firebase Authentication
            try await currentUser.delete()
            
            // Clear local state
            user = nil
            firestoreUser = nil
            
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Error deleting account: \(error.localizedDescription)")
            return false
        }
    }
}

struct ApplicationUtility {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        return root
    }
}

