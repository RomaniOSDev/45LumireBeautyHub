//
//  AppointmentsView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct AppointmentsView: View {
    @StateObject private var viewModel = AppointmentsViewModel()
    @State private var showingBooking = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.appointments.isEmpty {
                    EmptyAppointmentsView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if !viewModel.upcomingAppointments.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Upcoming")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.appTextPrimary)
                                        .padding(.horizontal)
                                    
                                    ForEach(viewModel.upcomingAppointments) { appointment in
                                        AppointmentCard(appointment: appointment) {
                                            viewModel.deleteAppointment(appointment)
                                        }
                                    }
                                }
                            }
                            
                            if !viewModel.pastAppointments.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Past")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.appTextPrimary)
                                        .padding(.horizontal)
                                    
                                    ForEach(viewModel.pastAppointments) { appointment in
                                        AppointmentCard(appointment: appointment) {
                                            viewModel.deleteAppointment(appointment)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Color.appBackground)
            .navigationTitle("My Appointments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingBooking = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.appPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingBooking) {
                BookingView()
            }
        }
    }
}

struct EmptyAppointmentsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.appPrimary)
            
            Text("No Appointments")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            Text("Book your first appointment to get started")
                .font(.system(size: 16))
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(appointment.serviceName ?? "")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                    
                    Text("with \(appointment.masterName)")
                        .font(.system(size: 16))
                        .foregroundColor(.appTextSecondary)
                }
                
                Spacer()
                
                Button {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.appPrimary)
                    Text(formatDate(appointment.date ?? Date()))
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.appPrimary)
                    Text(formatTime(appointment.date ?? Date()))
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                }
                
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.appPrimary)
                    Text(appointment.clientName ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                }
                
                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.appPrimary)
                    Text(appointment.clientPhone ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextPrimary)
                }
                
                if let notes = appointment.notes, !notes.isEmpty {
                    HStack(alignment: .top) {
                        Image(systemName: "note.text")
                            .foregroundColor(.appPrimary)
                        Text(notes)
                            .font(.system(size: 14))
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
        .alert("Delete Appointment", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this appointment?")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    AppointmentsView()
}
