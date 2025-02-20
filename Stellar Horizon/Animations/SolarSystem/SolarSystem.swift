//
//  SolarSystemView.swift
//  SpaceNews
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI

struct SolarSystem: View {
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
                PlanetView(color: .gray, size: 20, orbitRadius: 50, speed: 20.75)
                
                PlanetView(color: .blue, size: 25, orbitRadius: 100, speed: 8.15)
                
                PlanetView(color: .green, size: 30, orbitRadius: 150, speed: 5.00)
                
                PlanetView(color: .red, size: 28, orbitRadius: 200, speed: 2.65)
                
                PlanetView(color: .orange, size: 45, orbitRadius: 250, speed: 0.40)
                
                PlanetView(color: .yellow, size: 40, orbitRadius: 300, speed: 0.15)
                
                PlanetView(color: .blue, size: 35, orbitRadius: 350, speed: 0.055)
                
                PlanetView(color: .purple, size: 32, orbitRadius: 400, speed: 0.03)
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

