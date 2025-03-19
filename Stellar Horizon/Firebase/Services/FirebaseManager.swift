//
//  FirebaseManager.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 14.02.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    let auth = Auth.auth()
    let database = Firestore.firestore()
    var userId: String? {
        auth.currentUser?.uid
    }
}
