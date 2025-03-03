//
//  APODModel.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 06.01.25.
//

import Foundation

struct APODResponse: Codable {
    let title: String
    let explanation: String
    let url: String
    let date: String
    let mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title, explanation, url, date
        case mediaType = "media_type"
    }
}
