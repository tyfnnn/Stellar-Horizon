//
//  CreditsView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

struct CreditsView: View {
    struct TeamMember: Identifiable {
        let id = UUID()
        let name: String
        let role: String
        let imageName: String?
    }
    
    let team: [TeamMember] = [
        TeamMember(name: "Tayfun Ilker", role: "Lead Developer", imageName: nil)
    ]
    
    var body: some View {
        List {
            Section {
                ForEach(team) { member in
                    HStack(spacing: 16) {
                        if let imageName = member.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(member.name)
                                .font(.headline)
                            
                            Text(member.role)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("Team")
            }
            
            Section {
                Text("Special thanks to NASA, ESA, and the open-source community for providing data, images, and libraries that make this app possible.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } header: {
                Text("Acknowledgements")
            }
        }
        .navigationTitle("Credits")
    }
}
