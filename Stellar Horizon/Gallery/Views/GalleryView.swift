import SwiftUI

struct GalleryView: View {
    @Namespace private var transitionNamespace
    private let columns = [GridItem(.adaptive(minimum: 170))]
    @StateObject private var viewModel = GalleryViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoaderView()
                } else {
                    ScrollView {
                        NavigationLink(destination: APODView()) {
                            APODCoverView(namespace: transitionNamespace)
//                                .frame(height: 250)
                                .padding(.horizontal)
                                .padding(.top)
                        }
                        
                        LazyVGrid(columns: columns, spacing: 20) {
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

class GalleryViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var isLoading = false
    
    @MainActor
    func loadAlbums() {
        isLoading = true
        // Just load the static albums
        albums = Album.allAlbums
        isLoading = false
    }
}

struct AlbumCoverView: View {
    let album: Album
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: album.coverImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                LoaderView()
            }
            .frame(width: 175, height: 175)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .matchedGeometryEffect(id: album.id, in: namespace)
            
            VStack {
                Spacer()
                
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 175, height: 100)
            }
            
            VStack(alignment: .leading) {
                Text(album.agency)
                    .font(.caption)
                    .padding(.horizontal, 1)
                    .bold()
                    .clipShape(Capsule())
                
                Text(album.name)
                    .font(.headline)
                    .padding(.bottom, 4)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .foregroundStyle(.white)
            .padding(8)
        }
    }
}

#Preview {
    GalleryView()
}
