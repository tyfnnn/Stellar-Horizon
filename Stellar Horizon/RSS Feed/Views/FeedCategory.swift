//
//  FeedCategory.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import Foundation

struct FeedCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subcategories: [Subcategory]
    
    static let allCategories: [FeedCategory] = [
        FeedCategory(title: "NASA", subcategories: [
            Subcategory(title: "News Release", url: URL(string: "https://www.nasa.gov/news-release/feed/")!),
            Subcategory(title: "Technology", url: URL(string: "https://www.nasa.gov/technology/feed/")!)
        ]),
        FeedCategory(title: "ESA", subcategories: [
            Subcategory(title: "Observing the Earth", url: URL(string: "https://www.esa.int/rssfeed/Our_Activities/Observing_the_Earth")!),
            Subcategory(title: "Space Engineering & Technology", url: URL(string: "https://www.esa.int/rssfeed/Our_Activities/Space_Engineering_Technology")!),
            Subcategory(title: "Space Science", url: URL(string: "https://www.esa.int/rssfeed/Our_Activities/Space_Science")!)
        ]),
        FeedCategory(title: "Earh Observatory", subcategories: [
            Subcategory(title: "Latest News", url: URL(string: "https://earthobservatory.nasa.gov/feeds/earth-observatory.rss")!),
            Subcategory(title: "Natural Hazards", url: URL(string: "https://earthobservatory.nasa.gov/feeds/natural-hazards.rss")!)
        ])

    ]
}


