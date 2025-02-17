//
//  MainTabView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 05.02.25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(FirebaseViewModel.self) private var vm
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Space News", systemImage: "newspaper.fill")
                }
                .tag(0)
            
            GalleryView()
                .tabItem {
                    Label("Galerie", systemImage: "camera.aperture")
                }
                .tag(1)
            
            RotatingEarthView()
                .tabItem {
                    Label("Rotaing Earth ", systemImage: "globe.europe.africa.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
                .tag(3)
                .environment(vm)
        }
    }
}

#Preview {
    MainTabView()
}
