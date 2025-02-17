//
//  SettingsView.swift
//  TraumJobs
//
//  Created by Tayfun Ilker on 09.12.24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(FirebaseViewModel.self) private var vm
    @AppStorage("username") private var username: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("userBirthdate") private var birthdate: Double = Date().timeIntervalSince1970
    @AppStorage("userLocation") private var location: String = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("appLanguage") private var appLanguage: String = "Deutsch"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("fontSize") private var fontSize: Double = 1.0
    
    @State private var showingNotificationSettings = false
    @State private var showingDatePicker = false
    
    @AppStorage("notificationPreferences") private var notificationPreferences: Int = 0
    
    private let languages = ["Deutsch", "English", "Français", "Español", "Türkçe", "ελληνική", "اَلْعَرَبِيَّة"]
    
    var body: some View {
            
            NavigationStack {
                Form {
                    Section(header: Text("Persönliche Informationen")) {
                        TextField("Benutzername", text: $username)
                        TextField("E-Mail", text: $userEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Button(action: { showingDatePicker.toggle() }) {
                            HStack {
                                Text("Geburtsdatum")
                                Spacer()
                                Text(Date(timeIntervalSince1970: birthdate).formatted(date: .long, time: .omitted))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        TextField("Stadt", text: $location)
                    }
                    
                    Section(header: Text("Benachrichtigungen")) {
                        Toggle("Benachrichtigungen aktivieren", isOn: $notificationsEnabled)
                        
                        if notificationsEnabled {
                            Button("Benachrichtigungseinstellungen") {
                                showingNotificationSettings.toggle()
                            }
                        }
                    }
                    
                    Section(header: Text("App-Einstellungen")) {
                        Picker("Sprache", selection: $appLanguage) {
                            ForEach(languages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        
                        Toggle("Dark Mode", isOn: $isDarkMode)
                        
                        VStack {
                            Text("Schriftgröße")
                            Slider(value: $fontSize, in: 0.8...1.4, step: 0.1)
                            HStack {
                                Text("A").font(.system(size: 12))
                                Spacer()
                                Text("A").font(.system(size: 24))
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section {
                        Button(action: {
                            vm.signOut()
                        }) {
                            HStack {
                                Spacer()
                                Text("Sign out")
                                    .foregroundColor(.red)
                                    .bold()
                                Spacer()
                            }
                        }
                    }

                }
                .scrollContentBackground(.hidden)
                .background(Color("bgColors"))
                .navigationTitle("Einstellungen")
                .sheet(isPresented: $showingNotificationSettings) {
                    NotificationSettingsView(preferences: $notificationPreferences)
                }
                .sheet(isPresented: $showingDatePicker) {
                    DatePickerView(birthdate: $birthdate)
                }
                
            
        }
    }
}


#Preview {
    SettingsView()
        .environment(FirebaseViewModel())
}
