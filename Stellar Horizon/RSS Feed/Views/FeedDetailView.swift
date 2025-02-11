//
//  FeedDetailView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import SwiftUI

struct FeedDetailView: View {
    let item: FeedItem
    let category: Subcategory
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = item.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(12)
                    .padding(.bottom, 8)
                }
                
                Text(item.title)
                    .font(.title)
                
                Text(item.pubDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(item.description)
                    .font(.body)
                    .padding(.vertical, 8)
                
                NavigationLink(destination: WebDetailView(item: item)) {
                    Text("Read Full Article")
                        .font(.headline)
                }
            }
            .padding()
        }
        .navigationTitle(category.title)
    }
}
