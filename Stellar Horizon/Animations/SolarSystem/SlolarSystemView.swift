//
//  ContentView1.swift
//  SpaceNews
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI

struct SolarSystemView: View {
    @State private var selectedPlanet: Planet? = nil
    
    var body: some View {
        ZStack {
//            Color.black.ignoresSafeArea()
            
            SolarSystem(selectedPlanet: $selectedPlanet)
                .scaleEffect(0.45)
    
            
            VStack {
                if let selected = selectedPlanet {
                    Text(selected.name)
                        .font(.title)
                        .foregroundColor(.white)
                    Text(selected.description)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    SolarSystemView()
}
