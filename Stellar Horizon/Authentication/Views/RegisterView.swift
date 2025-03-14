//
//  RegisterView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 14.02.25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var vm: FirebaseViewModel
    @Binding var email: String
    @Binding var password: String
    @State private var name: String = ""
    @State private var birthDate: Date = Date()
    @State private var selectedGender: FirestoreUser.Gender = .preferNotToSay
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                
                Picker("Gender", selection: $selectedGender) {
                    ForEach(FirestoreUser.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue)
                    }
                }
                
                Button("Sign Up") {
                    Task {
                        await vm.signUp(
                            email: email,
                            password: password,
                            name: name,
                            birthDate: birthDate,
                            gender: selectedGender
                        )
                    }
                    if vm.isUserSignedIn {
                        dismiss()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Register")
            .padding()
            .background(Color("bgColors").opacity(0.5))
        }
    }
}

#Preview {
    RegisterView(
        vm: FirebaseViewModel(),
        email: .constant("test@example.com"),
        password: .constant("password")
    )
}
