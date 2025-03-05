//
//  CommentView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    let canEdit: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Profile image or placeholder
                if let profileImageURL = comment.userProfileImageURL, let url = URL(string: profileImageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.gray)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(comment.userName.isEmpty ? "Anonymous" : comment.userName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(comment.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if canEdit {
                    Menu {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: onDelete) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(8)
                            .contentShape(Rectangle())
                    }
                }
            }
            
            Text(comment.text)
                .font(.body)
                .padding(.leading, 4)
            
            if comment.edited {
                Text("Edited \(comment.lastEditTimestamp ?? comment.timestamp, style: .relative)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground).opacity(0.8))
        .cornerRadius(12)
    }
}

struct CommentListView: View {
    @Bindable var viewModel: PhotoInteractionViewModel
    @Environment(FirebaseViewModel.self) private var firebaseVM
    
    var body: some View {
        VStack {
            HStack {
                Text("Comments")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.comments.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
            if viewModel.isLoadingComments {
                LoaderView()
                    .frame(height: 100)
            } else if viewModel.comments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bubble.left")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No comments yet")
                        .foregroundStyle(.secondary)
                }
                .frame(height: 100)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.comments) { comment in
                            CommentView(
                                comment: comment,
                                canEdit: viewModel.canEditComment(comment),
                                onEdit: {
                                    viewModel.editComment(comment)
                                },
                                onDelete: {
                                    viewModel.deleteComment(comment)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            
            Divider()
                .padding(.horizontal)
            
            CommentEditorView(viewModel: viewModel)
                .padding(12)
        }
        .background(Color("bgColors"))
        .cornerRadius(16)
        .onAppear {
            // Ensure we have the current user ID
            if let userId = firebaseVM.userID {
                viewModel.loadInteractions(for: viewModel.photo, userId: userId)
            }
        }
    }
}

struct CommentEditorView: View {
    @Bindable var viewModel: PhotoInteractionViewModel
    
    var body: some View {
        VStack {
            HStack {
                TextField(
                    viewModel.editingComment != nil ? "Edit comment..." : "Add a comment...",
                    text: $viewModel.newCommentText,
                    axis: .vertical
                )
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .disabled(viewModel.isSubmittingComment)
                
                if !viewModel.newCommentText.isEmpty {
                    if viewModel.editingComment != nil {
                        Button(action: viewModel.cancelEditing) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .disabled(viewModel.isSubmittingComment)
                    }
                    
                    Button(action: viewModel.submitComment) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    .disabled(viewModel.isSubmittingComment || viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(.horizontal)
            
            if viewModel.isSubmittingComment {
                ProgressView()
                    .padding(.top, 4)
            }
        }
    }
}

#Preview {
    let photo = AstroPhoto(
        imageName: "test_image",
        title: "Test Photo",
        description: "Test description",
        date: "2025-03-03",
        credit: "NASA",
        photoId: "test123"
    )
    
    let viewModel = PhotoInteractionViewModel(photo: photo)
    
    return CommentListView(viewModel: viewModel)
        .environment(FirebaseViewModel())
}


import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let photoId: String
    let userId: String
    let text: String
    let timestamp: Date
    var edited: Bool = false
    var lastEditTimestamp: Date?
    var userName: String = ""
    var userProfileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoId = "photo_id"
        case userId = "user_id"
        case text
        case timestamp
        case edited
        case lastEditTimestamp = "last_edit_timestamp"
        case userName = "user_name"
        case userProfileImageURL = "user_profile_image_url"
    }
    
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "photo_id": photoId,
            "user_id": userId,
            "text": text,
            "timestamp": FieldValue.serverTimestamp(),
            "edited": edited,
            "user_name": userName
        ]
        
        if let lastEditTimestamp = lastEditTimestamp {
            dict["last_edit_timestamp"] = Timestamp(date: lastEditTimestamp)
        }
        
        if let userProfileImageURL = userProfileImageURL {
            dict["user_profile_image_url"] = userProfileImageURL
        }
        
        return dict
    }
}

import Foundation
import FirebaseFirestore

struct Like: Identifiable, Codable {
    @DocumentID var id: String?
    let photoId: String
    let userId: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoId = "photo_id"
        case userId = "user_id"
        case timestamp
    }
    
    var dictionary: [String: Any] {
        return [
            "photo_id": photoId,
            "user_id": userId,
            "timestamp": FieldValue.serverTimestamp()
        ]
    }
}

import Foundation
import FirebaseFirestore
import Combine

class PhotoInteractionService {
    private let db = FirebaseManager.shared.database
    private var listeners: [ListenerRegistration] = []
    
    // MARK: - Photo Management
    
    func trackPhoto(photoId: String, albumId: String, title: String, description: String, imageUrl: String, date: String, credit: String) async {
        let photoRef = db.collection("photos").document(photoId)
        
        do {
            let snapshot = try await photoRef.getDocument()
            if !snapshot.exists {
                try await photoRef.setData([
                    "id": photoId,
                    "albumId": albumId,
                    "title": title,
                    "description": description,
                    "imageUrl": imageUrl,
                    "date": date,
                    "credit": credit,
                    "likeCount": 0,
                    "commentCount": 0,
                    "timestamp": FieldValue.serverTimestamp()
                ])
            }
        } catch {
            print("Error tracking photo: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Likes
    
    func toggleLike(for photoId: String, by userId: String) async -> Bool {
        let photoRef = db.collection("photos").document(photoId)
        let likesRef = db.collection("likes")
        let query = likesRef.whereField("photo_id", isEqualTo: photoId).whereField("user_id", isEqualTo: userId)
        
        do {
            let snapshot = try await query.getDocuments()
            
            if let existingLike = snapshot.documents.first {
                // Remove like
                try await existingLike.reference.delete()
                
                // Update count
                try await photoRef.updateData([
                    "likeCount": FieldValue.increment(Int64(-1))
                ])
                
                return false // No longer liked
            } else {
                // Add like
                let like = Like(photoId: photoId, userId: userId, timestamp: Date())
                
                // Create like document
                try await likesRef.addDocument(data: like.dictionary)
                
                // Update count
                try await photoRef.updateData([
                    "likeCount": FieldValue.increment(Int64(1))
                ])
                
                return true // Now liked
            }
        } catch {
            print("Error toggling like: \(error.localizedDescription)")
            return false
        }
    }
    
    func checkIfLiked(photoId: String, userId: String) async -> Bool {
        let likesRef = db.collection("likes")
        let query = likesRef.whereField("photo_id", isEqualTo: photoId).whereField("user_id", isEqualTo: userId)
        
        do {
            let snapshot = try await query.getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            print("Error checking if liked: \(error.localizedDescription)")
            return false
        }
    }
    
    func getLikesCount(for photoId: String) async -> Int {
        let photoRef = db.collection("photos").document(photoId)
        
        do {
            let snapshot = try await photoRef.getDocument()
            return snapshot.data()?["likeCount"] as? Int ?? 0
        } catch {
            print("Error getting likes count: \(error.localizedDescription)")
            return 0
        }
    }
    
    // MARK: - Comments
    
    func addComment(photoId: String, userId: String, userName: String, userProfileImageURL: String?, text: String) async -> Comment? {
        let photoRef = db.collection("photos").document(photoId)
        let commentsRef = db.collection("comments")
        
        let comment = Comment(
            photoId: photoId,
            userId: userId,
            text: text,
            timestamp: Date(),
            userName: userName,
            userProfileImageURL: userProfileImageURL
        )
        
        do {
            // Add comment
            let docRef = try await commentsRef.addDocument(data: comment.dictionary)
            
            // Update comment count on photo
            try await photoRef.updateData([
                "commentCount": FieldValue.increment(Int64(1))
            ])
            
            // Create a complete comment with ID
            var newComment = comment
            newComment.id = docRef.documentID
            return newComment
        } catch {
            print("Error adding comment: \(error.localizedDescription)")
            return nil
        }
    }

    func editComment(commentId: String, newText: String) async -> Bool {
        let commentRef = db.collection("comments").document(commentId)
        
        do {
            try await commentRef.updateData([
                "text": newText,
                "edited": true,
                "last_edit_timestamp": FieldValue.serverTimestamp()
            ])
            return true
        } catch {
            print("Error editing comment: \(error.localizedDescription)")
            return false
        }
    }

    func deleteComment(commentId: String, photoId: String) async -> Bool {
        let commentRef = db.collection("comments").document(commentId)
        let photoRef = db.collection("photos").document(photoId)
        
        do {
            // Delete comment
            try await commentRef.delete()
            
            // Update count
            try await photoRef.updateData([
                "commentCount": FieldValue.increment(Int64(-1))
            ])
            
            return true
        } catch {
            print("Error deleting comment: \(error.localizedDescription)")
            return false
        }
    }
    
    func getComments(for photoId: String, limit: Int = 20) async -> [Comment] {
        let commentsRef = db.collection("comments")
            .whereField("photo_id", isEqualTo: photoId)
            .order(by: "timestamp", descending: false)
            .limit(to: limit)
        
        do {
            let snapshot = try await commentsRef.getDocuments()
            return snapshot.documents.compactMap { document in
                try? document.data(as: Comment.self)
            }
        } catch {
            print("Error getting comments: \(error.localizedDescription)")
            return []
        }
    }
    
    func listenForComments(photoId: String, completion: @escaping ([Comment]) -> Void) -> ListenerRegistration {
        let listener = db.collection("comments")
            .whereField("photo_id", isEqualTo: photoId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching comments: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                
                let comments = documents.compactMap { document in
                    try? document.data(as: Comment.self)
                }
                completion(comments)
            }
        
        listeners.append(listener)
        return listener
    }
    
    func removeListeners() {
        for listener in listeners {
            listener.remove()
        }
        listeners.removeAll()
    }
    
    deinit {
        removeListeners()
    }
}


import Foundation
import FirebaseFirestore
import Combine
import SwiftUI
import Observation

@Observable
class PhotoInteractionViewModel {
    private let photoInteractionService = PhotoInteractionService()
    private var listeners: [ListenerRegistration] = []
    
    private var currentPhotoId: String?
    private var currentUserId: String?
    
    // Adding the photo property to fix the reference issue
    var photo: AstroPhoto
    var comments: [Comment] = []
    var likeCount: Int = 0
    var isLiked: Bool = false
    var isLoadingLike: Bool = false
    var isLoadingComments: Bool = false
    var newCommentText: String = ""
    var editingComment: Comment?
    var isSubmittingComment: Bool = false
    
    init(photo: AstroPhoto) {
        self.photo = photo
        self.currentPhotoId = photo.photoId
    }
    
    func loadInteractions(for photo: AstroPhoto, userId: String?) {
        // Stop previous listeners
        for listener in listeners {
            listener.remove()
        }
        listeners.removeAll()
        
        self.photo = photo
        currentPhotoId = photo.photoId
        currentUserId = userId
        
        // Track photo in Firestore if it's not already there
        Task {
            if let photoId = currentPhotoId, let userID = currentUserId {
                await photoInteractionService.trackPhoto(
                    photoId: photoId,
                    albumId: "", // You might want to pass the album ID here
                    title: photo.title,
                    description: photo.description,
                    imageUrl: photo.imageName,
                    date: photo.date,
                    credit: photo.credit
                )
                
                // Load likes
                await loadLikes()
                
                // Load comments
                await loadComments()
                
                // Listen for comment updates
                let listener = photoInteractionService.listenForComments(photoId: photoId) { [weak self] comments in
                    Task { @MainActor in
                        self?.comments = comments
                    }
                }
                listeners.append(listener)
            }
        }
    }
    
    private func loadLikes() async {
        guard let photoId = currentPhotoId else { return }
        
        likeCount = await photoInteractionService.getLikesCount(for: photoId)
        
        if let userId = currentUserId {
            isLiked = await photoInteractionService.checkIfLiked(photoId: photoId, userId: userId)
        }
    }
    
    private func loadComments() async {
        guard let photoId = currentPhotoId else { return }
        
        isLoadingComments = true
        defer { isLoadingComments = false }
        
        comments = await photoInteractionService.getComments(for: photoId)
    }
    
    func toggleLike() {
        guard let photoId = currentPhotoId, let userId = currentUserId else { return }
        
        Task {
            isLoadingLike = true
            defer { isLoadingLike = false }
            
            // Optimistic UI update
            let wasLiked = isLiked
            isLiked = !isLiked
            likeCount += isLiked ? 1 : -1
            
            // Actual update
            let success = await photoInteractionService.toggleLike(for: photoId, by: userId)
            
            // If the server result is different from what we expected, revert our optimistic update
            if success != isLiked {
                isLiked = wasLiked
                await loadLikes() // Reload to get the accurate count
            }
        }
    }
    
    func submitComment() {
        guard let photoId = currentPhotoId, let userId = currentUserId, !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        Task {
            isSubmittingComment = true
            defer { isSubmittingComment = false }
            
            if let editingComment = editingComment, let commentId = editingComment.id {
                // Edit existing comment
                let success = await photoInteractionService.editComment(commentId: commentId, newText: newCommentText)
                if success {
                    self.editingComment = nil
                    newCommentText = ""
                }
            } else {
                // Add new comment
                // Get user info from Firebase
                var userName = "Anonymous"
                var userProfileImageURL: String? = nil
                
                if let firestoreUser = await getUserInfo(userId: userId) {
                    userName = firestoreUser.displayName ?? firestoreUser.name
                    userProfileImageURL = firestoreUser.profileImageURL
                }
                
                // Submit comment
                let _ = await photoInteractionService.addComment(
                    photoId: photoId,
                    userId: userId,
                    userName: userName,
                    userProfileImageURL: userProfileImageURL,
                    text: newCommentText
                )
                
                newCommentText = ""
            }
        }
    }
    
    private func getUserInfo(userId: String) async -> FirestoreUser? {
        do {
            let snapshot = try await FirebaseManager.shared.database
                .collection("users")
                .document(userId)
                .getDocument()
            
            return try snapshot.data(as: FirestoreUser.self)
        } catch {
            print("Error getting user info: \(error.localizedDescription)")
            return nil
        }
    }
    
    func editComment(_ comment: Comment) {
        editingComment = comment
        newCommentText = comment.text
    }
    
    func cancelEditing() {
        editingComment = nil
        newCommentText = ""
    }
    
    func deleteComment(_ comment: Comment) {
        guard let commentId = comment.id, let photoId = currentPhotoId else { return }
        
        Task {
            let success = await photoInteractionService.deleteComment(commentId: commentId, photoId: photoId)
            if success {
                if let index = comments.firstIndex(where: { $0.id == commentId }) {
                    comments.remove(at: index)
                }
            }
        }
    }
    
    func canEditComment(_ comment: Comment) -> Bool {
        comment.userId == currentUserId
    }
    
    deinit {
        for listener in listeners {
            listener.remove()
        }
    }
}
