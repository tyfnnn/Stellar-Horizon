//
//  Stellar_HorizonApp.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI
import FirebaseCore

@main
struct Stellar_HorizonApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
