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
