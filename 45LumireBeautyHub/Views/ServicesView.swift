//
//  ServicesView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct ServicesView: View {
    @StateObject private var viewModel = ServicesViewModel()
    @State private var selectedService: Service?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryChip(title: "All", isSelected: viewModel.selectedCategory == nil) {
                            viewModel.filterByCategory(nil)
                        }
                        
                        ForEach(viewModel.categories, id: \.self) { category in
                            CategoryChip(title: category, isSelected: viewModel.selectedCategory == category) {
                                viewModel.filterByCategory(category)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color.appBackground)
                
                // Services List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredServices) { service in
                            ServiceCard(service: service) {
                                selectedService = service
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Services")
            .sheet(item: $selectedService) { service in
                ServiceDetailView(service: service)
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .appTextPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.appPrimary : Color.gray.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct ServiceCard: View {
    let service: Service
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Image placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "scissors")
                            .font(.system(size: 30))
                            .foregroundColor(.appPrimary)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(service.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text(service.description)
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(2)
                    
                    HStack {
                        Label("\(service.duration) min", systemImage: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.appTextSecondary)
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ServiceDetailView: View {
    let service: Service
    @Environment(\.dismiss) var dismiss
    @StateObject private var mastersViewModel = MastersViewModel()
    @State private var selectedMaster: Master?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Image placeholder
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "scissors")
                                .font(.system(size: 50))
                                .foregroundColor(.appPrimary)
                        )
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(service.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.appTextPrimary)
                        
                        HStack {
                            Label("\(service.duration) min", systemImage: "clock")
                            Spacer()
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.appTextSecondary)
                        
                        Divider()
                        
                        Text("Description")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                        
                        Text(service.description)
                            .font(.system(size: 16))
                            .foregroundColor(.appTextSecondary)
                        
                        Divider()
                        
                        Text("Available Masters")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                        
                        ForEach(mastersViewModel.getMastersForService(service.id)) { master in
                            MasterRow(master: master) {
                                selectedMaster = master
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Service Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedMaster) { master in
                MasterDetailView(master: master, service: service)
            }
        }
    }
}

struct MasterRow: View {
    let master: Master
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.appPrimary)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(master.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text(master.specialization)
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
                    
                    HStack {
                        Label(String(format: "%.1f", master.rating), systemImage: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        
                        Text("\(master.experience) years exp.")
                            .font(.system(size: 12))
                            .foregroundColor(.appTextSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.appTextSecondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ServicesView()
}
