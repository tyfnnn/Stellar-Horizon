//
//  GalleryViewModel.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import Foundation

@Observable
class GalleryViewModel: ObservableObject {
    var albums: [Album] = []
    var isLoading = false
    
    @MainActor
    func loadAlbums() {
        isLoading = true
        albums = Album.allAlbums
        isLoading = false
    }
}
