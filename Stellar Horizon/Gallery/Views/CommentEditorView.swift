//
//  CommentEditorView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 05.03.25.
//

import SwiftUI

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
                    
                    Button(action: {
                        viewModel.submitComment()
                    }) {
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
