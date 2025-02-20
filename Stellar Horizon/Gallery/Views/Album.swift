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
    let coverImage: String  // This will be a local asset name
    let description: String
    let photos: [AstroPhoto]
    let photosetId: String  // Add this to store Flickr album ID
    
    static let allAlbums: [Album] = [
        Album(
            name: "Webb Deep Field",
            agency: "NASA",
            coverImage: "https://live.staticflickr.com/65535/54324515037_119b0f39c6_n.jpg&quot",
            description: "Images from the James Webb Space Telescope",
            photos: [],
            photosetId: "72177720323168468"  // Webb telescope photoset ID
        ),
        Album(
            name: "Hubble Latest",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/54327309698_f27edbf4f0_m.jpg&quot",
            description: "Classic images from the Hubble Space Telescope",
            photos: [],
            photosetId: "72157667717916603"  // Hubble telescope photoset ID
        ),
        Album(
            name: "Hubble Solar System",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53433104147_666cc3ba49.jpg&quot",
            description: "The Hubble Space Telescope's view of the planets and other objects orbiting our Sun.",
            photos: [],
            photosetId: "72157677485228358"  // Hubble telescope photoset ID
        ),
        Album(
            name: "Hubble Solar System",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53433104147_666cc3ba49.jpg&quot",
            description: "The Hubble Space Telescope's view of the planets and other objects orbiting our Sun.",
            photos: [],
            photosetId: "72157677485228358"  // Hubble telescope photoset ID
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
}



// Flickr API Response Models
struct FlickrPhotoResponse: Codable {
    let photoset: PhotosetContent
}

struct PhotosetContent: Codable {
    let photo: [FlickrPhoto]
}

struct FlickrPhoto: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    var photoURL: String {
        "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

class FlickrService {
    func fetchPhotosForAlbum(photosetId: String) async throws -> [AstroPhoto] {
        let urlString = "https://www.flickr.com/services/rest/?nojsoncallback=1&per_page=200&method=flickr.photosets.getPhotos&api_key=\(apiKeyFlickr)&photoset_id=\(photosetId)&format=json"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FlickrPhotoResponse.self, from: data)
        
        return response.photoset.photo.map { photo in
            AstroPhoto(
                imageName: photo.photoURL,
                title: photo.title,
                description: "Captured by NASA",
                date: "2024",
                credit: "NASA"
            )
        }
    }
}
