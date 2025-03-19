//
//  Album.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.02.25.
//

import SwiftUI

struct Album: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let agency: String
    let coverImage: String
    let description: String
    let photos: [AstroPhoto]
    let photosetId: String
    
    static let allAlbums: [Album] = [
        
        // James Webb
        Album(
            name: "Webb Images 2025",
            agency: "NASA",
            coverImage: "https://live.staticflickr.com/65535/54324515037_119b0f39c6_n.jpg&quot",
            description: "Images from the James Webb Space Telescope",
            photos: [],
            photosetId: "72177720323168468"
        ),
        Album(
            name: "Webb Images 2024",
            agency: "NASA",
            coverImage: "https://live.staticflickr.com/65535/54088897300_03f4f1647a_w.jpg&quot;",
            description: "Images from the James Webb Space Telescope",
            photos: [],
            photosetId: "72177720313923911"
        ),
        
        // Hubble
        Album(
            name: "Hubble Latest",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/54327309698_f27edbf4f0_m.jpg&quot",
            description: "Classic images from the Hubble Space Telescope",
            photos: [],
            photosetId: "72157667717916603" 
        ),
        Album(
            name: "Hubble Solar System",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53433104147_666cc3ba49.jpg&quot",
            description: "The Hubble Space Telescope's view of the planets and other objects orbiting our Sun.",
            photos: [],
            photosetId: "72157677485228358"
        ),
        Album(
            name: "Hubble's Galaxies",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53435087300_9764a31efd_m.jpg",
            description: "A collection of galaxy images from the Hubble Space Telescope",
            photos: [],
            photosetId: "72157695205167691"
        ),
        Album(
            name: "The Art of Hubble",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/52674991267_46b51e2981_n.jpg&quot;)",
            description: "Sometimes Hubble Space Telescope data is best visualized through art. Artists and scientists worked together to depict Hubble discoveries in these illustrations.",
            photos: [],
            photosetId: "72157710082072266"
        ),
        Album(
            name: "Hubble's Interracting Galaxies",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53502097195_afe806d8f2_n.jpg&quot;",
            description: "Galaxies reshaped by cosmic collisions and interactions, captured by the Hubble Space Telescope",
            photos: [],
            photosetId: "72157690798284953"
        ),
        Album(
            name: "Hubble's Nebulae",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53680290403_8e1f796ae6_w.jpg&quot;",
            description: "A Collection of Hubble Nebula Images",
            photos: [],
            photosetId: "72157661867344528"
        ),
        Album(
            name: "Selected Apollo 15 Photos",
            agency: "NASA",
            coverImage: "https://live.staticflickr.com/65535/51357005462_97135e04be_w.jpg&quot;",
            description: "The Hubble Space Telescope's view of the planets and other objects orbiting our Sun.",
            photos: [],
            photosetId: "72157719635893603"
        ),
        Album(
            name: "Earth From Space",
            agency: "ESA",
            coverImage: "https://live.staticflickr.com/5052/5496693274_a792025885_w.jpg&quot;",
            description: "More images of Earth from Space.",
            photos: [],
            photosetId: "72157626193417290"
        )
    ]
}

struct AstroPhoto: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let date: String
    let credit: String
    let photoId: String
}





