//
//  Master.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation

struct Master: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let specialization: String
    let experience: Int // years
    let rating: Double
    let bio: String
    let imageName: String
    let services: [String] // service IDs
}

struct MastersData: Codable {
    let masters: [Master]
}
