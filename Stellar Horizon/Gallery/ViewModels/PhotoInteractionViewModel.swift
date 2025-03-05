//
//  PhotoInteractionViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 05.03.25.
//

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
            if let photoId = currentPhotoId, let _ = currentUserId {
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
                setupCommentListener(photoId: photoId)
            }
        }
    }
    
    private func setupCommentListener(photoId: String) {
        let listener = photoInteractionService.listenForComments(photoId: photoId) { [weak self] newComments in
            guard let self = self else { return }
            
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                self.comments = newComments
                print("Comments updated: \(newComments.count) comments")
            }
        }
        listeners.append(listener)
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
        
        let fetchedComments = await photoInteractionService.getComments(for: photoId)
        
        // Update on main thread
        await MainActor.run {
            self.comments = fetchedComments
            print("Initial comments loaded: \(fetchedComments.count)")
        }
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
                if let newComment = await photoInteractionService.addComment(
                    photoId: photoId,
                    userId: userId,
                    userName: userName,
                    userProfileImageURL: userProfileImageURL,
                    text: newCommentText
                ) {
                    // Update comments array immediately for responsive UI
                    await MainActor.run {
                        // Add the new comment to the array if it's not already there
                        if !self.comments.contains(where: { $0.id == newComment.id }) {
                            self.comments.append(newComment)
                            print("Comment added locally: \(newComment.text)")
                        }
                    }
                }
                
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
                await MainActor.run {
                    if let index = comments.firstIndex(where: { $0.id == commentId }) {
                        comments.remove(at: index)
                        print("Comment deleted locally: \(commentId)")
                    }
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
