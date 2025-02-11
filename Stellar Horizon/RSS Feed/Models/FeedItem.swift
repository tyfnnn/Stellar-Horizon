//
//  FeedITem.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import Foundation

struct FeedItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let pubDate: Date
    let link: URL
    let subcategoryURL: URL
    let imageURL: URL? 
}
