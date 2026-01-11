//
//  MastersViewModel.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation
import Combine

class MastersViewModel: ObservableObject {
    @Published var masters: [Master] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadMasters()
    }
    
    func loadMasters() {
        masters = dataService.loadMasters()
    }
    
    func getMastersForService(_ serviceId: String) -> [Master] {
        return masters.filter { $0.services.contains(serviceId) }
    }
}
