//
//  ServicesViewModel.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation
import Combine

class ServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var filteredServices: [Service] = []
    @Published var selectedCategory: String? = nil
    
    private let dataService = DataService.shared
    
    init() {
        loadServices()
    }
    
    func loadServices() {
        services = dataService.loadServices()
        filteredServices = services
    }
    
    func filterByCategory(_ category: String?) {
        selectedCategory = category
        if let category = category {
            filteredServices = services.filter { $0.category == category }
        } else {
            filteredServices = services
        }
    }
    
    var categories: [String] {
        Array(Set(services.map { $0.category })).sorted()
    }
}
