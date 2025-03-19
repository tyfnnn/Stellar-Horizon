//
//  SettingsView.swift
//  TraumJobs
//
//  Created by Tayfun Ilker on 09.12.24.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @Environment(FirebaseViewModel.self) private var vm
    @Environment(\.dismiss) private var dismiss
    
    // App appearance settings
    @AppStorage("appTheme") private var appTheme: AppTheme = .cosmos
    @AppStorage("fontSize") private var fontSize: Double = 1.0
    
    // Notification settings
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationTypes") private var notificationTypes: Int = 0b11111
    @AppStorage("notificationQuietHours") private var notificationQuietHours: Bool = false
    @AppStorage("quietHoursStart") private var quietHoursStart: Int = 22
    @AppStorage("quietHoursEnd") private var quietHoursEnd: Int = 7
    
    // State variables
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var isShowingDeleteAccountAlert = false
    @State private var deleteAccountPassword: String = ""
    @State private var showDeleteConfirmation = false
    @State private var showDeleteError = false
    @State private var isShowingClearCacheAlert = false
    @State private var cacheSize: String = "Calculating..."
    
    @State private var showRegisterView = false
    @State private var email = ""
    @State private var password = ""
    
    // Modified to simply check if we should show the profile section
    private var shouldShowProfile: Bool {
        return !isAnonymous && vm.firestoreUser != nil
    }
    
    // Check if user is anonymous
    private var isAnonymous: Bool {
        return vm.isAnonymousUser()
    }
        
    var body: some View {
        NavigationStack {
            List {
                // PROFILE SECTION - Only shown for non-anonymous users with profile data
                if !isAnonymous {
                    Section {
                        if let firestoreUser = vm.firestoreUser {
                            ProfileHeaderView(
                                user: firestoreUser,
                                selectedPhotoItem: $selectedPhotoItem,
                                profileImage: $profileImage
                            )
                            
                            NavigationLink {
                                EditProfileView(vm: vm)
                            } label: {
                                Label("Edit Profile", systemImage: "person.text.rectangle")
                            }
                        } else {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .padding(.bottom, 4)
                                
                                Text("Loading profile information...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    } header: {
                        Text("Profile")
                    } footer: {
                        if let email = vm.getUserEmail(), !isAnonymous {
                            Text("Signed in as \(email)")
                        } else if isAnonymous {
                            Text("Signed in anonymously")
                        }
                    }
                } else {
                    // For anonymous users, show upgrade option
                    Section {
                        VStack(alignment: .center, spacing: 12) {
                            Image(systemName: "person.fill.questionmark")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding(.bottom, 8)
                            
                            Text("Anonymous Account")
                                .font(.headline)
                            
                            Text("Create an account to save your preferences and favorites across devices.")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                showRegisterView.toggle()
                            }) {
                                Text("Create Account")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    } header: {
                        Text("Account")
                    }
                }
                
                // APPEARANCE
                Section {
                    Picker("App Theme", selection: $appTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Text Size")
                            Spacer()
                            Text(fontSizeText)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("A")
                                .font(.system(size: 12))
                            Slider(value: $fontSize, in: 0.8...1.4, step: 0.1)
                                .tint(.blue)
                            Text("A")
                                .font(.system(size: 24))
                        }
                    }
                } header: {
                    Label("Appearance", systemImage: "paintpalette")
                }
                
                // NOTIFICATIONS
                Section {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .tint(.blue)
                    
                    if notificationsEnabled {
                        NavigationLink {
                            NotificationSettingsView(
                                notificationTypes: $notificationTypes,
                                quietHoursEnabled: $notificationQuietHours,
                                quietHoursStart: $quietHoursStart,
                                quietHoursEnd: $quietHoursEnd
                            )
                        } label: {
                            Label("Notification Settings", systemImage: "bell.badge")
                        }
                    }
                } header: {
                    Label("Notifications", systemImage: "bell")
                }
                
                // ABOUT APP
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About Stellar Horizon", systemImage: "info.circle")
                    }
                    
                    Link(destination: URL(string: "https://stellarhorizon.app/support")!) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    Link(destination: URL(string: "https://stellarhorizon.visual-stories.de/privacy-policy.html")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                } header: {
                    Label("About", systemImage: "doc.text")
                }
                
                // CACHE MANAGEMENT
                Section {
                    HStack {
                        Text("Cache Size")
                        Spacer()
                        Text(cacheSize)
                            .foregroundStyle(.secondary)
                    }
                    
                    Button(action: showClearCacheAlert) {
                        Label("Clear Cache", systemImage: "trash")
                    }
                    .foregroundStyle(.red)
                } header: {
                    Label("Storage", systemImage: "internaldrive")
                }
                
                // ACCOUNT ACTIONS
                Section {
                    Button(action: signOut) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .foregroundStyle(.red)
                    
                    if !isAnonymous {
                        Button(action: showDeleteAccountAlert) {
                            Label("Delete Account", systemImage: "person.crop.circle.badge.minus")
                        }
                        .foregroundStyle(.red)
                    }
                } header: {
                    Label("Account", systemImage: "person.crop.circle")
                } footer: {
                    Text("Version 1.0.0 (Build 42)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("bgColors"))
            .navigationTitle("Settings")
            .onAppear {
                // For both anonymous and regular users, only fetch if there's a userID
                if let userID = vm.userID {
                    // For anonymous users, we won't load previous profile data
                    if !isAnonymous {
                        vm.fetchUser(userID: userID)
                    }
                }
                calculateCacheSize()
            }
            .sheet(isPresented: $showRegisterView) {
                RegisterView(vm: vm, email: $email, password: $password)
                    .presentationDetents([.fraction(0.6)])
            }
            .sheet(isPresented: $showDeleteConfirmation) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Text("Confirm Account Deletion")
                            .font(.headline)
                            .padding(.top)
                        
                        Text("Please enter your password to confirm deletion of your account. This action cannot be undone.")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $deleteAccountPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            Button("Cancel") {
                                showDeleteConfirmation = false
                                deleteAccountPassword = ""
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Delete Account") {
                                showDeleteConfirmation = false
                                deleteAccount()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .disabled(deleteAccountPassword.isEmpty)
                        }
                        .padding(.bottom)
                    }
                    .padding()
                    .navigationTitle("Delete Account")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .alert("Clear Cache", isPresented: $isShowingClearCacheAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    clearCache()
                }
            } message: {
                Text("This will clear all cached images and data. Downloaded content will need to be re-downloaded.")
            }
            .alert("Delete Account", isPresented: $isShowingDeleteAccountAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
            } message: {
                Text("This will permanently delete your account and all associated data. This action cannot be undone.")
            }
            .alert("Error", isPresented: $showDeleteError) {
                Button("OK", role: .cancel) {
                    showDeleteError = false
                }
            } message: {
                Text(vm.errorMessage ?? "An error occurred while trying to delete your account. Please try again.")
            }
            .onChange(of: selectedPhotoItem) { _, newValue in
                if let newValue {
                    loadProfileImage(from: newValue)
                }
            }
        }
    }
    
    private var fontSizeText: String {
        switch fontSize {
        case 0.8: return "Small"
        case 0.9: return "Medium Small"
        case 1.0: return "Medium"
        case 1.1: return "Medium Large"
        case 1.2: return "Large"
        case 1.3: return "X-Large"
        case 1.4: return "XX-Large"
        default: return "Medium"
        }
    }
    
    private func calculateCacheSize() {
        // In a real app, this would actually calculate cache size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cacheSize = "47.3 MB"
        }
    }
    
    private func clearCache() {
        // Implement cache clearing logic here
        // For example: URLCache.shared.removeAllCachedResponses()
        
        // Update the display
        cacheSize = "0 B"
        
        // Simulate recalculation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            cacheSize = "0 B"
        }
    }
    
    private func loadProfileImage(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImage = image
                        // Here you would upload this image to Firebase Storage
                        // and update the user's profile
                    }
                }
            case .failure(let error):
                print("Photo loading error: \(error)")
            }
        }
    }
    
    private func signOut() {
        vm.signOut()
    }
    
    func deleteAccount() {
        Task {
            let success = await vm.deleteAccount()
            if success {
                // Account successfully deleted, user already signed out
                print("Account successfully deleted")
            } else {
                // Handle error - show alert with vm.errorMessage
                isShowingDeleteAccountAlert = false
                // In a complete implementation, we would show an error alert here
                print("Failed to delete account: \(vm.errorMessage ?? "Unknown error")")
            }
        }
    }
    
    private func showClearCacheAlert() {
        isShowingClearCacheAlert = true
    }
    
    private func showDeleteAccountAlert() {
        isShowingDeleteAccountAlert = true
    }
}

#Preview {
    SettingsView()
        .environment(FirebaseViewModel())
}



