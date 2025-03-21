//
//  Lottie.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 20.03.25.
//

import SwiftUI

struct Lottie: View {
    var body: some View {
        ZStack {
            Color("bgColors")
            LoaderView()
        }
    }
}

#Preview {
    Lottie()
}
