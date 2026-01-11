//
//  Article.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import Foundation

struct Article: Codable, Identifiable {
    let id: String
    let title: String
    let author: String
    let date: String
    let content: String
    let category: String
    let imageNames: [String]
    let tags: [String]
}

struct ArticlesData: Codable {
    let articles: [Article]
}
