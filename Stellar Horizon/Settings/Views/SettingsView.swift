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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    @AppStorage("appTheme") private var appTheme: AppTheme = .cosmos
    @AppStorage("fontSize") private var fontSize: Double = 1.0
    
    // App preferences
    @AppStorage("startupScreen") private var startupScreen: StartupScreen = .spaceNews
    @AppStorage("appLanguage") private var appLanguage: String = "English"
    @AppStorage("distanceUnit") private var distanceUnit: DistanceUnit = .kilometers
    @AppStorage("temperatureUnit") private var temperatureUnit: TemperatureUnit = .celsius
    
    // Notification settings
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationTypes") private var notificationTypes: Int = 0b11111
    @AppStorage("notificationQuietHours") private var notificationQuietHours: Bool = false
    @AppStorage("quietHoursStart") private var quietHoursStart: Int = 22
    @AppStorage("quietHoursEnd") private var quietHoursEnd: Int = 7
    
    // Media settings
    @AppStorage("downloadOverCellular") private var downloadOverCellular: Bool = false
    @AppStorage("imageQuality") private var imageQuality: ImageQuality = .high
    @AppStorage("autoplayVideos") private var autoplayVideos: Bool = true
    
    // State variables
    @State private var selectedLanguage: String = "English"
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var isShowingDeleteAccountAlert = false
    @State private var isShowingClearCacheAlert = false
    @State private var cacheSize: String = "Calculating..."
    
    let languages = ["English", "Español", "Français", "Deutsch", "中文", "日本語", "Русский", "العربية"]
    
    var body: some View {
        NavigationStack {
            List {
                // PROFILE SECTION
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
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                } header: {
                    Text("Profile")
                } footer: {
                    if let email = vm.firestoreUser?.email {
                        Text("Signed in as \(email)")
                    }
                }
                
                // APPEARANCE
                Section {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .tint(.blue)
                    
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
                
                // PREFERENCES
                Section {
                    Picker("Default Screen", selection: $startupScreen) {
                        ForEach(StartupScreen.allCases, id: \.self) { screen in
                            Text(screen.displayName).tag(screen)
                        }
                    }
                    
                    Picker("Language", selection: $appLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    
                    Picker("Distance Unit", selection: $distanceUnit) {
                        ForEach(DistanceUnit.allCases, id: \.self) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                    
                    Picker("Temperature Unit", selection: $temperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                } header: {
                    Label("Preferences", systemImage: "gear")
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
                
                // MEDIA & STORAGE
                Section {
                    Toggle("Download Over Cellular", isOn: $downloadOverCellular)
                        .tint(.blue)
                    
                    Picker("Image Quality", selection: $imageQuality) {
                        ForEach(ImageQuality.allCases, id: \.self) { quality in
                            Text(quality.displayName).tag(quality)
                        }
                    }
                    
                    Toggle("Autoplay Videos", isOn: $autoplayVideos)
                        .tint(.blue)
                    
                    Button(action: showClearCacheAlert) {
                        HStack {
                            Label("Clear Cache", systemImage: "trash")
                            Spacer()
                            Text(cacheSize)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.red)
                } header: {
                    Label("Media & Storage", systemImage: "photo.stack")
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
                    
                    Link(destination: URL(string: "https://stellarhorizon.app/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                } header: {
                    Label("About", systemImage: "doc.text")
                }
                
                // ACCOUNT ACTIONS
                Section {
                    Button(action: signOut) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .foregroundStyle(.red)
                    
                    Button(action: showDeleteAccountAlert) {
                        Label("Delete Account", systemImage: "person.crop.circle.badge.minus")
                    }
                    .foregroundStyle(.red)
                } header: {
                    Label("Account", systemImage: "person.crop.circle")
                } footer: {
                    Text("Version 1.0.0 (Build 42)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                if let userID = vm.userID {
                    vm.fetchUser(userID: userID)
                }
                calculateCacheSize()
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
    
    private func deleteAccount() {
        // In a real app, this would delete the user's account
        // For now, just sign out
        vm.signOut()
    }
    
    private func showClearCacheAlert() {
        isShowingClearCacheAlert = true
    }
    
    private func showDeleteAccountAlert() {
        isShowingDeleteAccountAlert = true
    }
}

// Supporting Views

struct ProfileHeaderView: View {
    let user: FirestoreUser
    @Binding var selectedPhotoItem: PhotosPickerItem?
    @Binding var profileImage: UIImage?
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile image
            ZStack {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else if let profileImageURL = user.profileImageURL, !profileImageURL.isEmpty {
                    AsyncImage(url: URL(string: profileImageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray)
                }
                
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        )
                        .opacity(0.6)
                }
            }
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.displayName ?? user.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let createdAt = user.createdAt {
                    Text("Member since \(createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

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

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Image("app-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                    
                    Text("Stellar Horizon")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Explore the Cosmos from Your Pocket")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 8)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            Section {
                NavigationLink {
                    CreditsView()
                } label: {
                    Label("Credits", systemImage: "person.3")
                }
                
                Link(destination: URL(string: "https://nasa.gov")!) {
                    Label("Data Sources", systemImage: "link")
                }
                
                NavigationLink {
                    Text("Licenses information would go here")
                        .padding()
                } label: {
                    Label("Open Source Licenses", systemImage: "doc.text")
                }
            } header: {
                Text("Information")
            }
            
            Section {
                Link(destination: URL(string: "https://stellarhorizon.app")!) {
                    Label("Website", systemImage: "globe")
                }
                
                Link(destination: URL(string: "https://twitter.com/stellarhorizon")!) {
                    Label("Twitter", systemImage: "person.crop.circle")
                }
                
                Link(destination: URL(string: "https://github.com/stellarhorizon")!) {
                    Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            } header: {
                Text("Connect")
            }
        }
        .navigationTitle("About")
    }
}

struct CreditsView: View {
    struct TeamMember: Identifiable {
        let id = UUID()
        let name: String
        let role: String
        let imageName: String?
    }
    
    let team: [TeamMember] = [
        TeamMember(name: "Tayfun Ilker", role: "Lead Developer", imageName: nil),
        TeamMember(name: "Jane Smith", role: "UI/UX Designer", imageName: nil),
        TeamMember(name: "Alex Johnson", role: "Data Scientist", imageName: nil)
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

// Supporting Models

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

#Preview {
    SettingsView()
        .environment(FirebaseViewModel())
}
