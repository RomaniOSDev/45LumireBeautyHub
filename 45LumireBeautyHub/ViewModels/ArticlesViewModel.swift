//
//  ArticlesViewModel.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var filteredArticles: [Article] = []
    @Published var selectedCategory: String? = nil
    
    private let dataService = DataService.shared
    
    init() {
        loadArticles()
    }
    
    func loadArticles() {
        articles = dataService.loadArticles()
        filteredArticles = articles
    }
    
    func filterByCategory(_ category: String?) {
        selectedCategory = category
        if let category = category {
            filteredArticles = articles.filter { $0.category == category }
        } else {
            filteredArticles = articles
        }
    }
    
    var categories: [String] {
        Array(Set(articles.map { $0.category })).sorted()
    }
}
