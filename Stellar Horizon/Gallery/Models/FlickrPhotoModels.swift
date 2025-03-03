//
//  FlickrPhotoResponse.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//


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