//
//  WideScreenLogo.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 21.02.25.
//

import SwiftUI

struct WideScreenLogo: View {
    var body: some View {
        ZStack {
            Color("bgColors")
            GeometryReader { geometry in
                SolarSystemView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(y: -22)
                WelcomeFontView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    WideScreenLogo()
}
