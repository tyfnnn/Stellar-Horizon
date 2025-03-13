//
//  NotificationSettingsView.swift
//  TraumJobs
//
//  Created by Tayfun Ilker on 09.12.24.
//

//import SwiftUI
//
//struct NotificationSettingsView: View {
//    @Binding var preferences: Int
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Toggle("Neue Stellenangebote", isOn: bindingForBit(0))
//                Toggle("Bewerbungsstatus", isOn: bindingForBit(1))
//                Toggle("Nachrichten", isOn: bindingForBit(2))
//                Toggle("Newsletter", isOn: bindingForBit(3))
//            }
//            .navigationTitle("Benachrichtigungen")
//            .toolbar {
//                Button("Fertig") {
//                    dismiss()
//                }
//            }
//        }
//    }
//    
//    private func bindingForBit(_ index: Int) -> Binding<Bool> {
//        Binding(
//            get: { preferences & (1 << index) != 0 },
//            set: { newValue in
//                if newValue {
//                    preferences |= (1 << index)
//                } else {
//                    preferences &= ~(1 << index)
//                }
//            }
//        )
//    }
//}
//
//#Preview {
//    NotificationSettingsView(preferences: .constant(1))
//}
