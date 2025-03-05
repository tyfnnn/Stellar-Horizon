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


