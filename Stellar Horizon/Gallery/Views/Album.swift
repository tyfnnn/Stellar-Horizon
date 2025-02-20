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
        
        // James Webb
        Album(
            name: "Webb Images 2025",
            agency: "NASA",
            coverImage: "https://live.staticflickr.com/65535/54324515037_119b0f39c6_n.jpg&quot",
            description: "Images from the James Webb Space Telescope",
            photos: [],
            photosetId: "72177720323168468"  // Webb telescope photoset ID
        ),
        Album(
            name: "Webb Images 2024",
            agency: "NASA",
            coverImage: "https://live.staticflickr.com/65535/54088897300_03f4f1647a_w.jpg&quot;",
            description: "Images from the James Webb Space Telescope",
            photos: [],
            photosetId: "72177720313923911"  // Webb telescope photoset ID
        ),
        
        // Hubble
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
            name: "Hubble's Galaxies",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53435087300_9764a31efd_m.jpg",
            description: "A collection of galaxy images from the Hubble Space Telescope",
            photos: [],
            photosetId: "72157695205167691"  // Hubble telescope photoset ID
        ),
        Album(
            name: "The Art of Hubble",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/52674991267_46b51e2981_n.jpg&quot;)",
            description: "Sometimes Hubble Space Telescope data is best visualized through art. Artists and scientists worked together to depict Hubble discoveries in these illustrations.",
            photos: [],
            photosetId: "72157710082072266"  // Hubble telescope photoset ID
        ),
        
        // 
        Album(
            name: "Hubble Solar System",
            agency: "NASA/ESA",
            coverImage: "https://live.staticflickr.com/65535/53433104147_666cc3ba49.jpg&quot",
            description: "The Hubble Space Telescope's view of the planets and other objects orbiting our Sun.",
            photos: [],
            photosetId: "72157677485228358"  // Hubble telescope photoset ID
        )
        ,
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
    let photoId: String  // Add this to store Flickr photo ID
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

// Add new models for photo info
struct FlickrPhotoInfoResponse: Codable {
    let photo: FlickrPhotoInfo
}

struct FlickrPhotoInfo: Codable {
    let title: FlickrContent
    let description: FlickrContent
    let dates: FlickrDates
    let owner: FlickrOwner
}

struct FlickrContent: Codable {
    let _content: String
}

struct FlickrDates: Codable {
    let taken: String
}

struct FlickrOwner: Codable {
    let realname: String
}

class FlickrService {
    func fetchPhotosForAlbum(photosetId: String) async throws -> [AstroPhoto] {
        let urlString = "https://www.flickr.com/services/rest/?nojsoncallback=1&per_page=20&method=flickr.photosets.getPhotos&api_key=\(apiKeyFlickr)&photoset_id=\(photosetId)&format=json"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FlickrPhotoResponse.self, from: data)
        
        // Fetch detailed info for each photo
        var astroPhotos: [AstroPhoto] = []
        for photo in response.photoset.photo {
            if let photoInfo = try? await fetchPhotoInfo(photoId: photo.id) {
                astroPhotos.append(AstroPhoto(
                    imageName: photo.photoURL,
                    title: photoInfo.title._content,
                    description: photoInfo.description._content,
                    date: photoInfo.dates.taken,
                    credit: photoInfo.owner.realname,
                    photoId: photo.id
                ))
            }
        }
        
        return astroPhotos
    }
    
    private func fetchPhotoInfo(photoId: String) async throws -> FlickrPhotoInfo {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(apiKeyFlickr)&photo_id=\(photoId)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FlickrPhotoInfoResponse.self, from: data)
        return response.photo
    }
}
