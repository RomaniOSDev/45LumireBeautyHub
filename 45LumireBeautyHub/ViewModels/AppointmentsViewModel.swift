//
//  AppointmentsViewModel.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation
import CoreData
import Combine

class AppointmentsViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    
    private let persistenceController = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadAppointments()
        observeChanges()
    }
    
    private func observeChanges() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.loadAppointments()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadAppointments() {
        let request: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Appointment.date, ascending: true)]
        
        do {
            appointments = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch appointments: \(error.localizedDescription)")
        }
    }
    
    func createAppointment(serviceName: String, masterName: String, date: Date, clientName: String, clientPhone: String, notes: String?) {
        let context = persistenceController.container.viewContext
        let appointment = Appointment(context: context)
        appointment.id = UUID()
        appointment.serviceName = serviceName
        appointment.masterName = masterName
        appointment.date = date
        appointment.clientName = clientName
        appointment.clientPhone = clientPhone
        appointment.notes = notes
        
        persistenceController.save()
        loadAppointments()
    }
    
    func deleteAppointment(_ appointment: Appointment) {
        let context = persistenceController.container.viewContext
        context.delete(appointment)
        persistenceController.save()
        loadAppointments()
    }
    
    var upcomingAppointments: [Appointment] {
        appointments.filter { appointment in
            guard let date = appointment.date else { return false }
            return date >= Date()
        }
    }
    
    var pastAppointments: [Appointment] {
        appointments.filter { appointment in
            guard let date = appointment.date else { return false }
            return date < Date()
        }
    }
}
