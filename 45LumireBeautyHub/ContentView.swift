//
//  ContentView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    
    var body: some View {
        TabView {
            ServicesView()
                .tabItem {
                    Label("Services", systemImage: "scissors")
                }
            
            MastersView()
                .tabItem {
                    Label("Masters", systemImage: "person.2")
                }
            
            BlogView()
                .tabItem {
                    Label("Blog", systemImage: "book")
                }
            
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "calendar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(.appPrimary)
        .onAppear {
            if !hasCompletedOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
    }
}

#Preview {
    ContentView()
}
