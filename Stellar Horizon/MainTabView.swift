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
            APODView()
                .tabItem {
                    Label("Galerie", systemImage: "briefcase.fill")
                }
                .tag(0)
            
            RotatingEarthView()
                .tabItem {
                    Label("Rotaing Earth ", systemImage: "globe.europe.africa.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
                .tag(2)
                .environment(vm)
        }
    }
}

#Preview {
    MainTabView()
}
