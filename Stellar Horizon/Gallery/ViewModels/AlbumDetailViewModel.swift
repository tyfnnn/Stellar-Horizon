//
//  AlbumDetailViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import SwiftUI

@Observable
class AlbumDetailViewModel: ObservableObject {
    var photos: [AstroPhoto] = []
    var isLoading = false
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
