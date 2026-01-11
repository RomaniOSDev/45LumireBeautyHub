//
//  DataService.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    func loadServices() -> [Service] {
        guard let url = Bundle.main.url(forResource: "services", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let servicesData = try? JSONDecoder().decode(ServicesData.self, from: data) else {
            return []
        }
        return servicesData.services
    }
    
    func loadMasters() -> [Master] {
        guard let url = Bundle.main.url(forResource: "masters", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let mastersData = try? JSONDecoder().decode(MastersData.self, from: data) else {
            return []
        }
        return mastersData.masters
    }
    
    func loadArticles() -> [Article] {
        guard let url = Bundle.main.url(forResource: "articles", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let articlesData = try? JSONDecoder().decode(ArticlesData.self, from: data) else {
            return []
        }
        return articlesData.articles
    }
}
