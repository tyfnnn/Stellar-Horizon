//
//  FeedItemCard.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import SwiftUI

struct FeedItemCard: View {
    let item: FeedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let imageURL = item.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 250, height: 250)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 150)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(.gray)
                }
                
                
                VStack {
                    Spacer()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: 250, height: 75)
                }
                
                VStack {
                    Spacer()
                    Text(item.title)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(8)
                }
            }
        }
        .frame(width: 250, height: 150)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(2)
    }
}
