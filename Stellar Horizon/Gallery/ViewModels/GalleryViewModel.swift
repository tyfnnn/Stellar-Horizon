//
//  GalleryViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import Foundation

class GalleryViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var isLoading = false
    
    @MainActor
    func loadAlbums() {
        isLoading = true
        albums = Album.allAlbums
        isLoading = false
    }
}
