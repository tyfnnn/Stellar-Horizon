//
//  Comment.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 05.03.25.
//


import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable, Equatable {
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
    
    // Implement Equatable
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id &&
               lhs.photoId == rhs.photoId &&
               lhs.userId == rhs.userId &&
               lhs.text == rhs.text &&
               lhs.timestamp == rhs.timestamp &&
               lhs.edited == rhs.edited &&
               lhs.lastEditTimestamp == rhs.lastEditTimestamp &&
               lhs.userName == rhs.userName &&
               lhs.userProfileImageURL == rhs.userProfileImageURL
    }
}