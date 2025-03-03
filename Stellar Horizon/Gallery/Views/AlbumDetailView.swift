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
    @State private var viewModel: AlbumDetailViewModel
    
    init(album: Album, transitionNamespace: Namespace.ID) {
        self.album = album
        self.transitionNamespace = transitionNamespace
        _viewModel = State(wrappedValue: AlbumDetailViewModel(album: album))
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
                    LoaderView()
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
        .background(Color("bgColors"))
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedPhoto) { photo in
            NavigationStack {
                ImageDetailView(photo: photo)
            }
        }
        .task {
            await viewModel.loadPhotos()
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        AlbumDetailView(album: Album.allAlbums[0], transitionNamespace: namespace)
    }
}
