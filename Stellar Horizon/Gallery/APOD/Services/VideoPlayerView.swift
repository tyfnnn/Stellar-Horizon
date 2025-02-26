//
//  VideoPlayerView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 05.02.25.
//

import SwiftUI
import WebKit

struct YouTubeVideoView: UIViewRepresentable {
    let url: String
    
    private var embedUrl: URL? {
        guard let videoID = URLComponents(string: url)?.queryItems?.first(where: { $0.name == "v" })?.value else {
            return URL(string: url)
        }
        return URL(string: "https://www.youtube.com/embed/\(videoID)")
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let embedUrl = embedUrl else { return }
        let request = URLRequest(url: embedUrl)
        uiView.load(request)
    }
}
