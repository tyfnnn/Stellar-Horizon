//
//  FlickrService.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import Foundation

class FlickrService {
    func fetchPhotosForAlbum(photosetId: String) async throws -> [AstroPhoto] {
        let urlString = "https://www.flickr.com/services/rest/?nojsoncallback=1&per_page=20&method=flickr.photosets.getPhotos&api_key=\(apiKeyFlickr)&photoset_id=\(photosetId)&format=json"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FlickrPhotoResponse.self, from: data)
        
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
