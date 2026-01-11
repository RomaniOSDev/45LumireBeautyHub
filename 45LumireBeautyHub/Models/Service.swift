//
//  Service.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation

struct Service: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let duration: Int // in minutes
    let category: String
    let imageName: String
}

struct ServicesData: Codable {
    let services: [Service]
}
