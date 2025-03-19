//
//  EditProfileView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: FirebaseViewModel
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var gender: FirestoreUser.Gender = .preferNotToSay
    @State private var birthDate: Date = Date()
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $name)
                TextField("Display Name", text: $displayName)
                
                Picker("Gender", selection: $gender) {
                    ForEach(FirestoreUser.Gender.allCases, id: \.self) { gender in
                        Text(gender.display).tag(gender)
                    }
                }
                
                DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
            }
            
            Section {
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        if let user = vm.firestoreUser {
            name = user.name
            displayName = user.displayName ?? ""
            gender = user.gender
            birthDate = user.birthDate
        }
    }
    
    private func saveChanges() {
        // In a real app, this would update the user's profile in Firestore
        // For now, we'll just dismiss
        dismiss()
    }
}
