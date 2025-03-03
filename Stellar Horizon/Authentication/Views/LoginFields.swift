//
//  LoginFields.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 14.02.25.
//

import SwiftUI

struct LoginFields: View {
    @Environment(FirebaseViewModel.self) private var vm
    let username = "Username"
    let password = "Password"
    @Binding var usernameInput: String
    @Binding var passwordInput: String
    @FocusState var isTypingUsername: Bool
    @FocusState var isTypingPassword: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            ZStack(alignment: .leading) {
                TextField("", text: $usernameInput).padding(.leading)
                    .frame(height: 55).focused($isTypingUsername)
                    .background(isTypingUsername ? .blue : Color.primary, in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 2))
                    .keyboardType(.emailAddress)
                Text(username).padding(.horizontal, 5)
                    .font(.exo2(fontStyle: .headline))
                    .background(Color("bgColors").cornerRadius(15).opacity(isTypingUsername || !usernameInput.isEmpty ? 1 : 0).cornerRadius(15))
                    .foregroundStyle(isTypingUsername ? .accentColor : Color.primary)
                    .padding(.leading).offset(y: isTypingUsername || !usernameInput.isEmpty ? -27 : 0)
            }
            .animation(.linear(duration: 0.2), value: isTypingUsername)
            
            ZStack(alignment: .leading) {
                SecureField("", text: $passwordInput).padding(.leading)
                    .frame(height: 55).focused($isTypingPassword)
                    .background(isTypingPassword ? .blue : Color.primary, in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 2))
                    .keyboardType(.emailAddress)
                Text(password).padding(.horizontal, 5)
                    .font(.exo2(fontStyle: .headline))
                    .background(Color("bgColors").cornerRadius(15).opacity(isTypingPassword || !passwordInput.isEmpty ? 1 : 0))
                    .foregroundStyle(isTypingPassword ? .accentColor : Color.primary)
                    .padding(.leading).offset(y: isTypingPassword || !passwordInput.isEmpty ? -27 : 0)
            }
            .animation(.linear(duration: 0.2), value: isTypingPassword)
            
            Button("Sign In") {
                Task {
                    await vm.signIn(email: usernameInput, password: passwordInput)
                }
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
}

