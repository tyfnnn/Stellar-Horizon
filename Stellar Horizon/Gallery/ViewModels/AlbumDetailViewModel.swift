//
//  AlbumDetailViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import SwiftUI

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
