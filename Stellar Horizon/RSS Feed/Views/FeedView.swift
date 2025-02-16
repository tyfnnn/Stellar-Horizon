//
//  FeedView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 07.02.25.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var loader = FeedLoader()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(FeedCategory.allCategories) { category in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category.title)
                                .font(.title)
                                .padding(.horizontal)
                            
                            ForEach(category.subcategories) { subcategory in
                                VStack(alignment: .leading) {
                                    Text(subcategory.title)
                                        .font(.headline)
                                        .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 15) {
                                            let items = loader.items.filter {
                                                $0.subcategoryURL == subcategory.url
                                            }
                                            
                                            if items.isEmpty {
                                                ProgressView()
                                                    .frame(width: 250, height: 150)
                                            } else {
                                                ForEach(items) { item in
                                                    NavigationLink(destination: FeedDetailView(item: item, category: subcategory)) {
                                                        FeedItemCard(item: item)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .background(Color("bgColors"))
            .navigationTitle("Space News")
            .toolbar {
                Button(action: {
                    loader.loadAllFeeds()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .overlay {
                if loader.isLoading {
                    LoaderView()
                } else if let error = loader.error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
            }
        }
        .task {
            if loader.items.isEmpty {
                loader.loadAllFeeds()
            }
        }
    }
}

#Preview {
    FeedView()
}
