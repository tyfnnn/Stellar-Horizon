//
//  PhotoDetailView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.02.25.
//

import SwiftUI

struct ImageDetailView: View {
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
                    LoaderView()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(photo.title)
                        .font(.exo2(fontStyle: .title))
                        .bold()
                    
                    Text(photo.date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(photo.description)
                        .font(.exo2(fontStyle: .body))
                        .padding(.top, 8)
                    
                    Text("Credit: \(photo.credit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
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
    }
}

#Preview {
    ImageDetailView(photo: AstroPhoto(
        imageName: "sample_image",
        title: "Sample Photo",
        description: "A beautiful cosmic view",
        date: "2024-02-17",
        credit: "NASA/ESA",
        photoId: "Sample"
    ))
}
