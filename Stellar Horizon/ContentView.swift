//
//  ContentView.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 11.02.25.
//

import SwiftUI

struct ContentView: View {
    @State private var vm = FirebaseViewModel()
    var body: some View {
        if vm.isUserSignedIn {
            MainTabView()
                .environment(vm)
        } else {
            AuthenticationView()
                .environment(vm)
        }
    }
}

#Preview {
    ContentView()
}

// Initial Commit
