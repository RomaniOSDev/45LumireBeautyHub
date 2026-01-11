//
//  BookingView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct BookingView: View {
    let service: Service?
    let master: Master?
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var appointmentsViewModel = AppointmentsViewModel()
    @StateObject private var servicesViewModel = ServicesViewModel()
    @StateObject private var mastersViewModel = MastersViewModel()
    
    @State private var selectedService: Service?
    @State private var selectedMaster: Master?
    @State private var selectedDate = Date()
    @State private var clientName = ""
    @State private var clientPhone = ""
    @State private var notes = ""
    @State private var showingSuccessAlert = false
    
    init(service: Service? = nil, master: Master? = nil) {
        self.service = service
        self.master = master
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Service") {
                    if let service = service {
                        Text(service.name)
                            .foregroundColor(.appTextPrimary)
                    } else {
                        Picker("Select Service", selection: $selectedService) {
                            Text("Select a service").tag(nil as Service?)
                            ForEach(servicesViewModel.services) { service in
                                Text(service.name).tag(service as Service?)
                            }
                        }
                    }
                }
                
                Section("Master") {
                    if let master = master {
                        Text(master.name)
                            .foregroundColor(.appTextPrimary)
                    } else {
                        Picker("Select Master", selection: $selectedMaster) {
                            Text("Select a master").tag(nil as Master?)
                            if let serviceId = (service ?? selectedService)?.id {
                                ForEach(mastersViewModel.getMastersForService(serviceId)) { master in
                                    Text(master.name).tag(master as Master?)
                                }
                            }
                        }
                        .disabled((service ?? selectedService) == nil)
                    }
                }
                
                Section("Date & Time") {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }
                
                Section("Your Information") {
                    TextField("Full Name", text: $clientName)
                    TextField("Phone Number", text: $clientPhone)
                        .keyboardType(.phonePad)
                }
                
                Section("Notes (Optional)") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Book") {
                        bookAppointment()
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Success", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your appointment has been booked successfully!")
            }
        }
        .onAppear {
            if let service = service {
                selectedService = service
            }
            if let master = master {
                selectedMaster = master
            }
        }
    }
    
    private var isFormValid: Bool {
        let finalService = service ?? selectedService
        let finalMaster = master ?? selectedMaster
        
        return finalService != nil &&
               finalMaster != nil &&
               !clientName.isEmpty &&
               !clientPhone.isEmpty
    }
    
    private func bookAppointment() {
        guard let finalService = service ?? selectedService,
              let finalMaster = master ?? selectedMaster else {
            return
        }
        
        appointmentsViewModel.createAppointment(
            serviceName: finalService.name,
            masterName: finalMaster.name,
            date: selectedDate,
            clientName: clientName,
            clientPhone: clientPhone,
            notes: notes.isEmpty ? nil : notes
        )
        
        showingSuccessAlert = true
    }
}

#Preview {
    BookingView()
}
