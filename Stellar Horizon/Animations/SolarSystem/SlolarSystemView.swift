//
//  ContentView1.swift
//  SpaceNews
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI

struct SolarSystemView: View {
    var body: some View {
        ZStack {
            SolarSystem()
                .scaleEffect(0.45)
        }
    }
}

#Preview {
    SolarSystemView()
}
