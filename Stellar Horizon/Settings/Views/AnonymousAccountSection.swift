//
//  AnonymousAccountSection.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

// Modified SettingsView section for anonymous users
struct AnonymousAccountSection: View {
    @Environment(FirebaseViewModel.self) private var vm
    @State private var showRegisterView = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        Section {
            VStack(alignment: .center, spacing: 12) {
                Image(systemName: "person.fill.questionmark")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                Text("Anonymous Account")
                    .font(.headline)
                
                Text("Create an account to save your preferences and favorites across devices.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    showRegisterView.toggle()
                }) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showRegisterView) {
                AnonymousUpgradeView(vm: vm)
                    .presentationDetents([.fraction(0.75)])
            }
        } header: {
            Text("Account")
        }
    }
}
