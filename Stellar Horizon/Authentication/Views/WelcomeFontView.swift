//
//  WelcomeFontView.swift
//  Code Snippets
//
//  Created by Tayfun Ilker on 28.01.25.
//

import SwiftUI

struct WelcomeFontView: View {
    var body: some View {
        VStack {
            SomeText()
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .overlay {
                    MeshGradientView()
                        .mask {
                            SomeText()
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                }
        }
    }
}

struct SomeText: View {
    var body: some View {
        VStack {
            Text("STELLAR")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("HORIZON")
                .font(.system(size: 80))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}


struct MeshGradientView: View {
    @State private var animate = false
    
    let colors: [Color] = [
        .blue,
        .purple,
        .pink,
        .orange
    ]
    
    var body: some View {
        ZStack {
            // Erstelle mehrere überlappende Kreise mit verschiedenen Farben
            ForEach(0..<colors.count, id: \.self) { index in
                Circle()
                    .fill(colors[index])
                    .frame(width: 250, height: 250)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? CGFloat(index * 200 - 150) : CGFloat(index * -200 + 150),
                        y: animate ? CGFloat(index * 50 - 75) : CGFloat(index * -50 + 75)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 5)
                .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
}

#Preview {
    WelcomeFontView()
}
