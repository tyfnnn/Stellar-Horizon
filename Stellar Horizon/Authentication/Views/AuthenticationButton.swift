//
//  AuthenticationView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 13.02.25.
//

import SwiftUI

struct AuthenticationButton: View {
    let icon: String
    let text: String
    let isSystemIcon: Bool
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isSystemIcon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Text(text)
                    .foregroundColor(foregroundColor)
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(backgroundColor)
            )
        }
        .padding(.horizontal)
    }
}
