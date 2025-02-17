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
    private var firestoreUser: FirestoreUser?
    
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
        } catch {
            errorMessage = error.localizedDescription
            print("Error")
        }
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
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
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

