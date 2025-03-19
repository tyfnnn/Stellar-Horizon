//
//  AnonymousUpgradeView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 19.03.25.
//

import SwiftUI

// Special registration view for anonymous users
struct AnonymousUpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: FirebaseViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var displayName = ""
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var selectedGender: FirestoreUser.Gender = .preferNotToSay
    @State private var errorMessage = ""
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                }
                
                Section(header: Text("Profile Information")) {
                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                    
                    TextField("Display Name (optional)", text: $displayName)
                    
                    DatePicker(
                        "Birth Date",
                        selection: $birthDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(FirestoreUser.Gender.allCases, id: \.self) { gender in
                            Text(gender.display).tag(gender)
                        }
                    }
                }
                
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
                
                Section {
                    Button(action: upgradeAccount) {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Upgrade Account")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .disabled(!isFormValid || isProcessing)
                }
            }
            .navigationTitle("Create Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .disabled(isProcessing)
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") &&
        !password.isEmpty && password.count >= 6 &&
        password == confirmPassword &&
        !name.isEmpty
    }
    
    private func upgradeAccount() {
        guard isFormValid else { return }
        
        isProcessing = true
        errorMessage = ""
        
        Task {
            // Upgrade the anonymous user
            await vm.upgradeAnonymousAccount(
                email: email,
                password: password,
                name: name,
                displayName: displayName.isEmpty ? nil : displayName,
                birthDate: birthDate,
                gender: selectedGender
            )
            
            // Check if the upgrade was successful
            if vm.errorMessage == nil {
                dismiss()
            } else {
                errorMessage = vm.errorMessage ?? "Unknown error occurred"
            }
            
            isProcessing = false
        }
    }
}


enum AppTheme: String, CaseIterable {
    case cosmos
    case mars
    case nebula
    case deepSpace
    case blackHole
    
    var displayName: String {
        switch self {
        case .cosmos: return "Cosmos (Default)"
        case .mars: return "Mars"
        case .nebula: return "Nebula"
        case .deepSpace: return "Deep Space"
        case .blackHole: return "Black Hole"
        }
    }
}

enum StartupScreen: String, CaseIterable {
    case spaceNews
    case gallery
    case satelliteTracker
    case earth
    
    var displayName: String {
        switch self {
        case .spaceNews: return "Space News"
        case .gallery: return "Gallery"
        case .satelliteTracker: return "Satellite Tracker"
        case .earth: return "Earth View"
        }
    }
}

enum DistanceUnit: String, CaseIterable {
    case kilometers
    case miles
    case astronomicalUnits
    case lightYears
    
    var displayName: String {
        switch self {
        case .kilometers: return "Kilometers (km)"
        case .miles: return "Miles (mi)"
        case .astronomicalUnits: return "Astronomical Units (AU)"
        case .lightYears: return "Light Years (ly)"
        }
    }
}

enum TemperatureUnit: String, CaseIterable {
    case celsius
    case fahrenheit
    case kelvin
    
    var displayName: String {
        switch self {
        case .celsius: return "Celsius (°C)"
        case .fahrenheit: return "Fahrenheit (°F)"
        case .kelvin: return "Kelvin (K)"
        }
    }
}

enum ImageQuality: String, CaseIterable {
    case low
    case medium
    case high
    
    var displayName: String {
        switch self {
        case .low: return "Low (Save Data)"
        case .medium: return "Medium"
        case .high: return "High (Best Quality)"
        }
    }
}
