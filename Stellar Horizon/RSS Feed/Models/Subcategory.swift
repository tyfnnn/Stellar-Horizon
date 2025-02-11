//
//  Subcategory.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import Foundation

struct Subcategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let url: URL
}
