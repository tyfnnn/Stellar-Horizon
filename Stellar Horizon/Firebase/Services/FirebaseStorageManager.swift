//
//  FirebaseStorageManager.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import FirebaseStorage
import UIKit

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let storage = Storage.storage()
    
    func uploadProfileImage(_ image: UIImage, userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Resize and compress the image
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            completion(.failure(NSError(domain: "FirebaseStorageManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        // Use a flatter path structure to avoid nested path issues
        let imageRef = storage.reference().child("profile_" + userId + ".jpg")
        
        // Upload the data with minimal configuration
        _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // Get download URL after successful upload
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "FirebaseStorageManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                    return
                }
                
                completion(.success(downloadURL.absoluteString))
            }
        }
    }
    
    // Update deleteProfileImage to use the same path structure
    func deleteProfileImage(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let imageRef = storage.reference().child("profile_" + userId + ".jpg")
        
        imageRef.delete { error in
            if let error = error {
                // If file doesn't exist, we consider it a success
                if (error as NSError).domain == StorageErrorDomain &&
                   (error as NSError).code == StorageErrorCode.objectNotFound.rawValue {
                    completion(.success(()))
                    return
                }
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
