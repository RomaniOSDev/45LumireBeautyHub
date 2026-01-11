//
//  BlogView.swift
//  45LumireBeautyHub
//
//  Created by Роман Главацкий on 09.01.2026.
//

import SwiftUI

struct BlogView: View {
    @StateObject private var viewModel = ArticlesViewModel()
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryChip(title: "All", isSelected: viewModel.selectedCategory == nil) {
                            viewModel.filterByCategory(nil)
                        }
                        
                        ForEach(viewModel.categories, id: \.self) { category in
                            CategoryChip(title: category, isSelected: viewModel.selectedCategory == category) {
                                viewModel.filterByCategory(category)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color.appBackground)
                
                // Articles List
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.filteredArticles) { article in
                            ArticleCard(article: article) {
                                selectedArticle = article
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Beauty Blog")
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
        }
    }
}

struct ArticleCard: View {
    let article: Article
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                // Image
                if let firstImageName = article.imageNames.first {
                    Image(firstImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(article.category.uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.appPrimary)
                    
                    Text(article.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.appTextPrimary)
                        .lineLimit(2)
                    
                    HStack {
                        Text(article.author)
                            .font(.system(size: 14))
                            .foregroundColor(.appTextSecondary)
                        
                        Text("•")
                            .foregroundColor(.appTextSecondary)
                        
                        Text(article.date)
                            .font(.system(size: 14))
                            .foregroundColor(.appTextSecondary)
                    }
                    
                    Text(article.content)
                        .font(.system(size: 14))
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(3)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Image Gallery
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(article.imageNames, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 200)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(article.category.uppercased())
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.appPrimary)
                        
                        Text(article.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.appTextPrimary)
                        
                        HStack {
                            Text(article.author)
                                .font(.system(size: 16))
                                .foregroundColor(.appTextSecondary)
                            
                            Text("•")
                                .foregroundColor(.appTextSecondary)
                            
                            Text(article.date)
                                .font(.system(size: 16))
                                .foregroundColor(.appTextSecondary)
                        }
                        
                        Divider()
                        
                        Text(article.content)
                            .font(.system(size: 16))
                            .foregroundColor(.appTextSecondary)
                            .lineSpacing(4)
                        
                        if !article.tags.isEmpty {
                            Divider()
                            
                            Text("Tags")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.appTextPrimary)
                            
                            FlowLayout(items: article.tags) { tag in
                                Text(tag)
                                    .font(.system(size: 12))
                                    .foregroundColor(.appPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.appPrimary.opacity(0.1))
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FlowLayout: View {
    let items: [String]
    let content: (String) -> AnyView
    
    init(items: [String], @ViewBuilder content: @escaping (String) -> some View) {
        self.items = items
        self.content = { AnyView(content($0)) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(stride(from: 0, to: items.count, by: 3)), id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(rowIndex..<min(rowIndex + 3, items.count), id: \.self) { index in
                        content(items[index])
                    }
                }
            }
        }
    }
}

#Preview {
    BlogView()
}
