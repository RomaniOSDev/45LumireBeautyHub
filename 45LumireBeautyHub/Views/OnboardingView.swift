//
//  OnboardingView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                OnboardingPage(
                    imageName: "girl1",
                    title: "Welcome to Lumiére Beauty Hub",
                    description: "Discover our premium beauty services and expert masters. Book appointments with ease and explore our beauty blog."
                )
                .tag(0)
                
                OnboardingPage(
                    imageName: "girl2",
                    title: "Expert Masters",
                    description: "Meet our professional team of beauty experts. Each master specializes in different services to give you the best experience."
                )
                .tag(1)
                
                OnboardingPage(
                    imageName: "girl3",
                    title: "Beauty Blog",
                    description: "Stay updated with the latest beauty tips, trends, and articles from our experts. Learn and discover new beauty secrets."
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack(spacing: 16) {
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                        isPresented = false
                    }
                }) {
                    HStack {
                        Spacer()
                        Text(currentPage < 2 ? "Next" : "Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.appPrimary)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                if currentPage < 2 {
                    Button(action: {
                        hasCompletedOnboarding = true
                        isPresented = false
                    }) {
                        Text("Skip")
                            .font(.system(size: 16))
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.appBackground)
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipped()
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
