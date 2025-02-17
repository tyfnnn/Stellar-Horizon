//
//  GalleryView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 17.02.25.
//

import SwiftUI

struct GalleryCategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subcategories: [GallerySubcategory]
    
    static let allCategories: [GalleryCategory] = [
        GalleryCategory(title: "NASA", subcategories: [
            GallerySubcategory(title: "Astronomy Picture of the Day", source: .nasa_apod),
            GallerySubcategory(title: "James Webb Telescope", source: .nasa_webb),
            GallerySubcategory(title: "Mars Rovers", source: .nasa_mars)
        ]),
        GalleryCategory(title: "ESA", subcategories: [
            GallerySubcategory(title: "Hubble Highlights", source: .esa_hubble),
            GallerySubcategory(title: "Earth Observation", source: .esa_earth)
        ])
    ]
}

struct GallerySubcategory: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let source: PhotoSource
}

enum PhotoSource {
    case nasa_apod
    case nasa_webb
    case nasa_mars
    case esa_hubble
    case esa_earth
}

struct GalleryView: View {
    @StateObject private var apodViewModel = APODViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // APOD Featured Section
                    VStack(alignment: .leading) {
                        Text("Featured Today")
                            .font(.title)
                            .padding(.horizontal)
                        
                        if let apod = apodViewModel.apod {
                            NavigationLink(destination: APODView()) {
                                VStack(alignment: .leading) {
                                    AsyncImage(url: URL(string: apod.url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                            .frame(height: 200)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("NASA's Picture of the Day")
                                            .font(.headline)
                                        Text(apod.title)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                }
                                .background(Color("bgColors"))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Categories
                    ForEach(GalleryCategory.allCategories) { category in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(category.title)
                                .font(.title)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(category.subcategories) { subcategory in
                                        NavigationLink(destination: Text(subcategory.title)) {
                                            GalleryItemCard(title: subcategory.title)
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
            .background(Color("bgColors"))
            .navigationTitle("Gallery")
        }
        .onAppear {
            apodViewModel.fetchAPOD()
        }
    }
}

struct GalleryItemCard: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("HDR_multi_nebulae") // Placeholder image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 150)
                .clipped()
            
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        .background(Color("bgColors"))
        .cornerRadius(12)
    }
}

#Preview {
    GalleryView()
}
