import SwiftUI

struct Album: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let agency: String
    let coverImage: String
    let description: String
    let photos: [AstroPhoto]
    
    static let allAlbums: [Album] = [
        Album(
            name: "Webb Deep Field",
            agency: "NASA",
            coverImage: "webb_deep_field",
            description: "Images from the James Webb Space Telescope",
            photos: [
                // You would need to add actual photos here
            ]
        ),
        Album(
            name: "Hubble Legacy",
            agency: "NASA/ESA",
            coverImage: "hubble_legacy",
            description: "Classic images from the Hubble Space Telescope",
            photos: [
                // You would need to add actual photos here
            ]
        )
        // Add more albums as needed
    ]
}

struct AstroPhoto: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let date: String
    let credit: String
}
