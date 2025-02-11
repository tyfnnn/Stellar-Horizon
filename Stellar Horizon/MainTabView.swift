//
//  MainTabView.swift
//  NASA APOD
//
//  Created by Tayfun Ilker on 05.02.25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            APODView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase.fill")
                }
                .tag(0)
            
            APODView()
                .tabItem {
                    Label("Favoriten", systemImage: "star.fill")
                }
                .tag(1)
            
            APODView()
                .tabItem {
                    Label("Einstellungen", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}
