//
//  AlbumCoverView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 03.03.25.
//

import SwiftUI

struct AlbumCoverView: View {
    let album: Album
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: album.coverImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                LoaderView()
            }
            .frame(width: 175, height: 175)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .matchedGeometryEffect(id: album.id, in: namespace)
            
            VStack {
                Spacer()
                
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 175, height: 100)
            }
            
            VStack(alignment: .leading) {
                Text(album.agency)
                    .font(.exo2(fontStyle: .caption))
                    .padding(.horizontal, 1)
                    .bold()
                    .clipShape(Capsule())
                
                Text(album.name)
                    .font(.exo2(fontStyle: .headline, fontWeight: .regular))
                    .padding(.bottom, 4)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .foregroundStyle(.white)
            .padding(8)
        }
    }
}
