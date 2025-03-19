//
//  ImageDetailView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import SwiftUI

struct ImageDetailView: View {
    let photo: AstroPhoto
    @Environment(\.dismiss) private var dismiss
    @Environment(FirebaseViewModel.self) private var firebaseVM
    
    @State private var isImageViewerPresented = false
    @State private var showComments = false
    @State private var viewModel: PhotoInteractionViewModel
    
    // This is used to identify the comments section for scrolling
    @Namespace private var commentsNamespace
    
    init(photo: AstroPhoto) {
        self.photo = photo
        _viewModel = State(wrappedValue: PhotoInteractionViewModel(photo: photo))
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: photo.imageName)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                            .onTapGesture {
                                isImageViewerPresented = true
                            }
                    } placeholder: {
                        LoaderView()
                    }
                    
                    HStack {
                        // Like button
                        Button(action: {
                            viewModel.toggleLike()
                        }) {
                            HStack {
                                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isLiked ? .red : .gray)
                                
                                Text("\(viewModel.likeCount)")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        }
                        .disabled(viewModel.isLoadingLike)
                        
                        // Comment button
                        Button(action: {
                            showComments.toggle()
                            
                            // When comments are toggled to show, scroll to the comments section
                            if showComments {
                                withAnimation {
                                    scrollProxy.scrollTo(commentsNamespace, anchor: .top)
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "bubble.left")
                                    .foregroundColor(.gray)
                                
                                Text("\(viewModel.comments.count)")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(photo.title)
                            .font(.title)
                            .bold()
                        
                        Text(photo.date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(photo.description)
                            .padding(.top, 8)
                        
                        Text("Credit: \(photo.credit)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                    }
                    
                    if showComments {
                        CommentListView(viewModel: viewModel)
                            .padding(.top, 8)
                            .id(commentsNamespace)
                    }
                }
                .padding()
            }
            .background(Color("bgColors"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $isImageViewerPresented) {
                if let imageURL = URL(string: photo.imageName) {
                    ImageViewer(image: imageURL)
                }
            }
            .onChange(of: showComments) { oldValue, newValue in
                // Additional check to ensure we only scroll when comments are toggled on
                if newValue && !oldValue {
                    withAnimation {
                        scrollProxy.scrollTo(commentsNamespace, anchor: .top)
                    }
                }
            }
            .task {
                if let userId = firebaseVM.userID {
                    viewModel.loadInteractions(for: photo, userId: userId)
                }
            }
        }
    }
}

#Preview {
    let mockFirebaseVM = FirebaseViewModel()
    
    return NavigationStack {
        ImageDetailView(photo: AstroPhoto(
            imageName: "https://apod.nasa.gov/apod/image/2402/NGC1566_JwstTomlinson_1080.jpg", // Use an actual URL
            title: "Sample Photo",
            description: "A beautiful cosmic view of a spiral galaxy captured by the James Webb Space Telescope. This sample image showcases the detailed structures and vibrant colors often found in deep space objects.",
            date: "2024-02-17",
            credit: "NASA/ESA/JWST",
            photoId: "sample_id"
        ))
        .environment(mockFirebaseVM)
    }
}
