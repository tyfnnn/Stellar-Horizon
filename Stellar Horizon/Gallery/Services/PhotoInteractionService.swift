//
//  PhotoInteractionService.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 05.03.25.
//

import Foundation
import FirebaseFirestore

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
    
    func getComments(for photoId: String, limit: Int = 50) async -> [Comment] {
        let commentsRef = db.collection("comments")
            .whereField("photo_id", isEqualTo: photoId)
            .order(by: "timestamp", descending: false)
            .limit(to: limit)
        
        do {
            let snapshot = try await commentsRef.getDocuments()
            print("Fetched \(snapshot.documents.count) comments from Firestore")
            
            return snapshot.documents.compactMap { document in
                do {
                    var comment = try document.data(as: Comment.self)
                    // Make sure each comment has its document ID
                    comment.id = document.documentID
                    return comment
                } catch {
                    print("Error parsing comment document: \(error)")
                    return nil
                }
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
                
                print("Snapshot listener received update with \(documents.count) comments")
                let comments = documents.compactMap { document -> Comment? in
                    do {
                        var comment = try document.data(as: Comment.self)
                        // Make sure each comment has its document ID
                        comment.id = document.documentID
                        return comment
                    } catch {
                        print("Error parsing comment in listener: \(error)")
                        return nil
                    }
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
