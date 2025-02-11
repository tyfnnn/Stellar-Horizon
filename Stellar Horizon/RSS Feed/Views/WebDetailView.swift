//
//  WebDetailView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 10.02.25.
//

import SwiftUI

struct WebDetailView: View {
    let item: FeedItem

    var body: some View {
        WebView(url: item.link)
            .navigationTitle(item.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

