//
//  LoaderView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 06.02.25.
//

import SwiftUI
import Lottie

struct LoaderView: View {
    var body: some View {
        LottieView(animation: .named("AstronautLoader"))
            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
            .frame(width: 100, height: 100) 
    }
}

#Preview {
    LoaderView()
}
