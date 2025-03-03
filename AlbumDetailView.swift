import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    let transitionNamespace: Namespace.ID
    @State private var selectedPhoto: AstroPhoto?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(album.coverImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .matchedGeometryEffect(id: album.id, in: transitionNamespace)
                
                Text(album.name)
                    .font(.title)
                    .bold()
                
                Text(album.description)
                    .foregroundStyle(.secondary)
                
                Text("Photos")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(album.photos) { photo in
                        Image(photo.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                            .onTapGesture {
                                selectedPhoto = photo
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
    }
}

#Preview {
    @Namespace var namespace
    NavigationStack {
        AlbumDetailView(album: Album.allAlbums[0], transitionNamespace: namespace)
    }
}
