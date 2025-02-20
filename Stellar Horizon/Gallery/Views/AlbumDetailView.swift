//
//  AlbumDetailView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.02.25.
//

import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    let transitionNamespace: Namespace.ID
    @State private var selectedPhoto: AstroPhoto?
    @StateObject private var viewModel: AlbumDetailViewModel
    
    init(album: Album, transitionNamespace: Namespace.ID) {
        self.album = album
        self.transitionNamespace = transitionNamespace
        _viewModel = StateObject(wrappedValue: AlbumDetailViewModel(album: album))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) { 
                Text(album.name)
                    .font(.title)
                    .bold()
                
                Text(album.description)
                    .foregroundStyle(.secondary)
                
                Text("Photos")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(viewModel.photos) { photo in
                            AsyncImage(url: URL(string: photo.imageName)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                            .onTapGesture {
                                selectedPhoto = photo
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedPhoto) { photo in
            NavigationStack {
                PhotoDetailView(photo: photo)
            }
        }
        .task {
            await viewModel.loadPhotos()
        }
    }
}

class AlbumDetailViewModel: ObservableObject {
    @Published var photos: [AstroPhoto] = []
    @Published var isLoading = false
    private let album: Album
    private let flickrService = FlickrService()
    
    init(album: Album) {
        self.album = album
    }
    
    @MainActor
    func loadPhotos() async {
        isLoading = true
        do {
            photos = try await flickrService.fetchPhotosForAlbum(photosetId: album.photosetId)
        } catch {
            print("Error loading photos: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        AlbumDetailView(album: Album.allAlbums[0], transitionNamespace: namespace)
    }
}
