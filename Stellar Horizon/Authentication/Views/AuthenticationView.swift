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
                
                WelcomeFontView()
                
                Spacer()
                
                LoginFields(usernameInput: $email, passwordInput: $password)
                    .padding(.bottom,50)
                    .environment(vm)
                
                VStack(spacing: 12) {
                    AuthenticationButton(
                        icon: "anonym",
                        text: "Sign in anonymously",
                        isSystemIcon: false,
                        foregroundColor: .white,
                        backgroundColor: .green
                    ) {
                        Task {
                            await vm.signInAnonymously()
                        }
                        print("Signed in anonymously")
                    }
                    
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
                    
                    Button {
                        showRegisterView.toggle()
                    } label: {
                        HStack {
                            Text("Don't have an account? Sign Up")
                                .foregroundColor(.white)
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                        )
                    }
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showRegisterView) {
                    RegisterView(vm: vm, email: $email, password: $password)
                        .presentationDetents([.fraction(0.6)])
                }
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
