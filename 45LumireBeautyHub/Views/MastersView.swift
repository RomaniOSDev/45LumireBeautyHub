//
//  MastersView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct MastersView: View {
    @StateObject private var viewModel = MastersViewModel()
    @State private var selectedMaster: Master?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.masters) { master in
                        MasterCard(master: master) {
                            selectedMaster = master
                        }
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Our Masters")
            .sheet(item: $selectedMaster) { master in
                MasterDetailView(master: master)
            }
        }
    }
}

struct MasterCard: View {
    let master: Master
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // Image
                Image(master.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(master.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text(master.specialization)
                        .font(.system(size: 16))
                        .foregroundColor(.appPrimary)
                    
                    HStack {
                        Label(String(format: "%.1f", master.rating), systemImage: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                        
                        Text("•")
                            .foregroundColor(.appTextSecondary)
                        
                        Text("\(master.experience) years experience")
                            .font(.system(size: 14))
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    Text(master.bio)
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(3)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MasterDetailView: View {
    let master: Master
    let service: Service?
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var servicesViewModel = ServicesViewModel()
    @State private var selectedService: Service?
    
    init(master: Master, service: Service? = nil) {
        self.master = master
        self.service = service
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Image
                    Image(master.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(16)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(master.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.appTextPrimary)
                        
                        Text(master.specialization)
                            .font(.system(size: 20))
                            .foregroundColor(.appPrimary)
                        
                        HStack {
                            Label(String(format: "%.1f", master.rating), systemImage: "star.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.orange)
                            
                            Text("•")
                                .foregroundColor(.appTextSecondary)
                            
                            Text("\(master.experience) years experience")
                                .font(.system(size: 16))
                                .foregroundColor(.appTextSecondary)
                        }
                        
                        Divider()
                        
                        Text("About")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                        
                        Text(master.bio)
                            .font(.system(size: 16))
                            .foregroundColor(.appTextSecondary)
                        
                        if let service = service {
                            Divider()
                            
                            Button(action: {
                                selectedService = service
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Book \(service.name)")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.appPrimary)
                                .cornerRadius(12)
                            }
                        } else {
                            Divider()
                            
                            Text("Services")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appTextPrimary)
                            
                            ForEach(master.services, id: \.self) { serviceId in
                                if let service = servicesViewModel.services.first(where: { $0.id == serviceId }) {
                                    ServiceRow(service: service) {
                                        selectedService = service
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Master Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedService) { service in
                BookingView(service: service, master: master)
            }
        }
    }
}

struct ServiceRow: View {
    let service: Service
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text("\(service.duration) min")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
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
    MastersView()
}
