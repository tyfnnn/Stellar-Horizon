//
//  PlanetView.swift
//  SpaceNews
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI

struct PlanetView: View {
    var color: Color
    var size: CGFloat
    var orbitRadius: CGFloat
    var speed: Double
    
    @State private var angle: Double = Double.random(in: 0..<360)
    
    var body: some View {
        let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
        
        return Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(x: orbitRadius * cos(angle), y: orbitRadius * sin(angle))
            .onReceive(timer) { _ in
                angle += speed / 1000
            }
    }
}
