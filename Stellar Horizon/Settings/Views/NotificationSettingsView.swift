//
//  NotificationSettingsView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

struct NotificationSettingsView: View {
    @Binding var notificationTypes: Int
    @Binding var quietHoursEnabled: Bool
    @Binding var quietHoursStart: Int
    @Binding var quietHoursEnd: Int
    
    struct NotificationType: Identifiable {
        let id: Int
        let name: String
        let description: String
        let icon: String
    }
    
    let types: [NotificationType] = [
        NotificationType(id: 0, name: "Space News", description: "Breaking space news and discoveries", icon: "newspaper"),
        NotificationType(id: 1, name: "ISS Passes", description: "When the ISS is visible from your location", icon: "scope"),
        NotificationType(id: 2, name: "Astronomy Events", description: "Notable celestial events", icon: "star"),
        NotificationType(id: 3, name: "Satellite Updates", description: "Changes to tracked satellites", icon: "satellite"),
        NotificationType(id: 4, name: "New Photos", description: "When new astro photos are available", icon: "photo")
    ]
    
    var body: some View {
        List {
            Section {
                ForEach(types) { type in
                    Toggle(isOn: binding(for: type.id)) {
                        Label {
                            VStack(alignment: .leading) {
                                Text(type.name)
                                    .fontWeight(.medium)
                                Text(type.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: type.icon)
                                .foregroundStyle(.blue)
                        }
                    }
                    .tint(.blue)
                }
            } header: {
                Text("Notification Types")
            }
            
            Section {
                Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)
                    .tint(.blue)
                
                if quietHoursEnabled {
                    HStack {
                        Text("From")
                        Spacer()
                        Picker("Start Time", selection: $quietHoursStart) {
                            ForEach(0..<24) { hour in
                                Text("\(hour):00").tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Text("to")
                        
                        Picker("End Time", selection: $quietHoursEnd) {
                            ForEach(0..<24) { hour in
                                Text("\(hour):00").tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            } header: {
                Text("Quiet Hours")
            } footer: {
                Text("No notifications will be sent during quiet hours")
            }
        }
        .navigationTitle("Notification Settings")
    }
    
    private func binding(for index: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: { (notificationTypes & (1 << index)) != 0 },
            set: { newValue in
                if newValue {
                    notificationTypes |= (1 << index)
                } else {
                    notificationTypes &= ~(1 << index)
                }
            }
        )
    }
}
