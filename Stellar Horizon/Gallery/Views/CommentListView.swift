//
//  CommentListView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 05.03.25.
//

import SwiftUI

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
                .onChange(of: viewModel.comments) { _, newComments in
                    print("Comment list updated: \(newComments.count) comments")
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
            print("CommentListView appeared with \(viewModel.comments.count) comments")
            // Ensure we have the current user ID
            if let userId = firebaseVM.userID {
                viewModel.loadInteractions(for: viewModel.photo, userId: userId)
            }
        }
    }
}
