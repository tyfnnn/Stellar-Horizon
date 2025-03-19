//
//  ProfileHeaderView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI
import PhotosUI

struct ProfileHeaderView: View {
    let user: FirestoreUser
    @Binding var selectedPhotoItem: PhotosPickerItem?
    @Binding var profileImage: UIImage?
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile image
            ZStack {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else if let profileImageURL = user.profileImageURL, !profileImageURL.isEmpty {
                    AsyncImage(url: URL(string: profileImageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray)
                }
                
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        )
                        .opacity(0.6)
                }
            }
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.displayName ?? user.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let createdAt = user.createdAt {
                    Text("Member since \(createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
