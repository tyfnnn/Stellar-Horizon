//
//  ImageViewer.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 20.02.25.
//

import SwiftUI

struct ImageViewer: View {
    let image: URL
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                AsyncImage(url: image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit) // Änderung von scaledToFill zu aspectRatio
                        .frame(width: geometry.size.width, height: geometry.size.height) // Fügt einen Frame hinzu
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / lastScale
                                    lastScale = value
                                    let newScale = scale * delta
                                    scale = min(max(1.0, newScale), 4.0) // Begrenzt den Zoom zwischen 1x und 4x
                                }
                                .onEnded { _ in
                                    lastScale = 1.0
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let maxOffset = (scale - 1) * geometry.size.width / 2
                                    let newOffset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                    
                                    // Begrenzt die Bewegung basierend auf der Skalierung
                                    offset = CGSize(
                                        width: min(maxOffset, max(-maxOffset, newOffset.width)),
                                        height: min(maxOffset, max(-maxOffset, newOffset.height))
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                        .gesture(
                            TapGesture(count: 2)
                                .onEnded {
                                    withAnimation {
                                        scale = scale > 1 ? 1 : 2
                                        if scale == 1 {
                                            offset = .zero
                                            lastOffset = .zero
                                        }
                                    }
                                }
                        )
                } placeholder: {
                    ZStack {
                        Color.black
                        LoaderView()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}


