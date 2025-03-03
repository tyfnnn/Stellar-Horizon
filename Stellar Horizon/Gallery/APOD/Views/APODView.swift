//
//  ContentView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 06.01.25.
//

import SwiftUI
import AVKit
import Lottie

struct APODView: View {
    @StateObject private var viewModel = APODViewModel()
    @State private var isImageDetailPresented = false
    @State private var loadedImage: Image? = nil  // Neuer State für das geladene Bild

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let apod = viewModel.apod {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            if apod.mediaType == "video" {
                                if apod.url.contains("youtube.com") {
                                    YouTubeVideoView(url: apod.url)
                                        .aspectRatio(16/9, contentMode: .fit)
                                        .frame(minHeight: 200)
                                } else {
                                    VideoPlayer(player: AVPlayer(url: URL(string: apod.url)!))
                                        .aspectRatio(16/9, contentMode: .fit)
                                        .frame(minHeight: 200)
                                }
                            } else {
                                AsyncImage(url: URL(string: apod.url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .onTapGesture {
                                            isImageDetailPresented = true
                                        }
                                } placeholder: {
                                    ZStack {
                                        Color.black
                                        LoaderView()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                }
                                .fullScreenCover(isPresented: $isImageDetailPresented) {
                                    ImageViewer(image: URL(string: apod.url)!)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(apod.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(apod.date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(apod.explanation)
                                    .font(.body)
                            }
                            .padding(.horizontal)
                        }
                    }
                } else if let error = viewModel.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                        Text(error.localizedDescription)
                    }
                }
            }
            .background(Color("bgColors"))
            .navigationTitle("NASA APOD")
        }
        .onAppear {
            viewModel.fetchAPOD()
        }
    }
}

#Preview {
    APODView()
}
