//
//  Like.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 05.03.25.
//

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
