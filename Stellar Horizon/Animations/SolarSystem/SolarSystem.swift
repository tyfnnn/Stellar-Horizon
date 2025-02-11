//
//  SolarSystemView.swift
//  SpaceNews
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI

struct SolarSystem: View {
    @Binding var selectedPlanet: Planet?
    
    var body: some View {
        ZStack {            
            Circle()
                .fill(Color.orange)
                .frame(width: 50, height: 50)
            
            ForEach(1..<9) { index in
                Circle()
                    .stroke(orbitColor(for: index), lineWidth: 1)
                    .frame(width: CGFloat(index) * 100, height: CGFloat(index) * 100)
            }
            
            Group {
                PlanetView(color: .gray, size: 20, orbitRadius: 50, speed: 20.75, name: "Mercury", description: "The closest planet to the Sun", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .blue, size: 25, orbitRadius: 100, speed: 8.15, name: "Venus", description: "Earth's twin", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .green, size: 30, orbitRadius: 150, speed: 5.00, name: "Earth", description: "Home planet", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .red, size: 28, orbitRadius: 200, speed: 2.65, name: "Mars", description: "The red planet", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .orange, size: 45, orbitRadius: 250, speed: 0.40, name: "Jupiter", description: "The largest planet", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .yellow, size: 40, orbitRadius: 300, speed: 0.15, name: "Saturn", description: "Known for its rings", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .blue, size: 35, orbitRadius: 350, speed: 0.055, name: "Uranus", description: "The sideways planet", selectedPlanet: $selectedPlanet)
                
                PlanetView(color: .purple, size: 32, orbitRadius: 400, speed: 0.03, name: "Neptune", description: "Farthest from the Sun", selectedPlanet: $selectedPlanet)
            }
        }
    }
    
    private func orbitColor(for index: Int) -> Color {
        switch index {
        case 0:
            return .gray
        case 1:
            return .blue
        case 2:
            return .green
        case 3:
            return .red
        case 4:
            return .orange
        case 5:
            return .yellow
        case 6:
            return .blue
        case 7:
            return .purple
        default:
            return Color.white
        }
    }
}

