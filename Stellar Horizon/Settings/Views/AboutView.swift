//
//  AboutView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                ZStack {
                    GeometryReader { geometry in
                        SolarSystemView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(y: -22)
                    }
                    
                    VStack(spacing: 16) {
                        Image("app-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                        
                        Text("Stellar Horizon")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Explore the Cosmos from Your Pocket")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            
            Section {
                NavigationLink {
                    CreditsView()
                } label: {
                    Label("Credits", systemImage: "person.3")
                }
                
                Link(destination: URL(string: "https://nasa.gov")!) {
                    Label("Data Sources", systemImage: "link")
                }
                
                NavigationLink {
                    OpenSourceLicensesView()
                } label: {
                    Label("Open Source Licenses", systemImage: "doc.text")
                }
            } header: {
                Text("Information")
            }
            
            Section {
                Link(destination: URL(string: "https://stellarhorizon.visual-stories.de")!) {
                    Label("Website", systemImage: "globe")
                }
                
                Link(destination: URL(string: "https://github.com/tyfnnn")!) {
                    Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            } header: {
                Text("Connect")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("bgColors"))
        .navigationTitle("About")
    }
}
