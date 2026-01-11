//
//  SettingsView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    SettingsRow(
                        icon: "star.fill",
                        iconColor: .orange,
                        title: "Rate Us",
                        action: {
                            rateApp()
                        }
                    )
                }
                
                Section("Legal") {
                    SettingsRow(
                        icon: "lock.shield.fill",
                        iconColor: .appPrimary,
                        title: "Privacy Policy",
                        action: {
                            openURL("https://example.com/privacy-policy")
                        }
                    )
                    
                    SettingsRow(
                        icon: "doc.text.fill",
                        iconColor: .appPrimary,
                        title: "Terms of Service",
                        action: {
                            openURL("https://example.com/terms-of-service")
                        }
                    )
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Lumiére Beauty Hub")
                            .font(.system(size: 14))
                            .foregroundColor(.appTextSecondary)
                        Text("v1.0.0")
                            .font(.system(size: 14))
                            .foregroundColor(.appTextSecondary)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.appTextPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appTextSecondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}
