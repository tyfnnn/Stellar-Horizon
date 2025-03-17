import SwiftUI

struct GalleryView: View {
    @Namespace private var transitionNamespace
    private let columns = [GridItem(.adaptive(minimum: 170))]
    @State private var viewModel = GalleryViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoaderView()
                } else {
                    ScrollView {
                        NavigationLink(destination: APODView()) {
                            APODCoverView(namespace: transitionNamespace)
                                .padding(.horizontal)
                                .padding(.top)
                        }
                        
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(viewModel.albums) { album in
                                NavigationLink(value: album) {
                                    AlbumCoverView(album: album, namespace: transitionNamespace)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationDestination(for: Album.self) { album in
                AlbumDetailView(album: album, transitionNamespace: transitionNamespace)
            }
            .background(Color("bgColors"))
            .navigationTitle("Astro Gallery")
        }
        .onAppear {
            viewModel.loadAlbums()
        }
    }
}

#Preview {
    GalleryView()
}
