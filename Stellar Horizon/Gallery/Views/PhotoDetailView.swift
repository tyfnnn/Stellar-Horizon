//
//  PhotoDetailView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.02.25.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: AstroPhoto
    @Environment(\.dismiss) private var dismiss
    @State private var isImageViewerPresented = false
    
    var body: some View {
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
                    ProgressView()
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
            }
            .padding()
        }
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
    }
}

#Preview {
    PhotoDetailView(photo: AstroPhoto(
        imageName: "sample_image",
        title: "Sample Photo",
        description: "A beautiful cosmic view",
        date: "2024-02-17",
        credit: "NASA/ESA"
    ))
}
