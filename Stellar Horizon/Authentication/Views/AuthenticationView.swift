//
//  AuthenticationView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 14.02.25.
//

import SwiftUI

struct AuthenticationView: View {
    @Environment(FirebaseViewModel.self) private var vm
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var showRegisterView: Bool = false
    
    var body: some View {
        ZStack {
            Color("bgColors").ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    GeometryReader { geometry in
                        SolarSystemView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(y: -22)
                        WelcomeFontView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                Spacer()
                
                LoginFields(usernameInput: $email, passwordInput: $password)
                    .padding(.bottom, 8)
                    .environment(vm)
                
                Button {
                    showRegisterView.toggle()
                } label: {
                    HStack {
                        Text("Don't have an account? Sign Up")
                            .font(.exo2(fontStyle: .callout, fontWeight: .regular))
                            .foregroundColor(.accentColor)
                    }
                }
                .font(.subheadline)
                .padding(.horizontal)
                
                Text("or")
                    .font(.subheadline)
                
                Button {
                    Task {
                        await vm.signInAnonymously()
                    }
                    print("Signed in anonymously")
                } label: {
                    HStack {
                        Text("Sign in anonymously")
                            .font(.exo2(fontStyle: .callout, fontWeight: .regular))
                            .foregroundColor(.accentColor)
                    }
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.bottom)
                
                VStack(spacing: 12) {
                    AuthenticationButton(
                        icon: "google",
                        text: "Sign up with Google",
                        isSystemIcon: false,
                        foregroundColor: .black,
                        backgroundColor: .white
                    ) {
                        Task {
                            await vm.signInWithGoogle()
                        }
                    }
                    
                }
                .sheet(isPresented: $showRegisterView) {
                    RegisterView(vm: vm, email: $email, password: $password)
                        .presentationDetents([.fraction(0.6)])
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }
    }
}
