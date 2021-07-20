//
//  NewsStand.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import SwiftUI

class NewsStand: ObservableObject {
    @Environment(\.openURL) var openURL
    private var newsService: NewsServiceComposite
    @Published var articles: [ArticleViewModel] = []
    
    init(service: NewsServiceComposite = NewsServiceComposite()) {
        self.newsService = service
    }
    
    func getArticles(){
        self.newsService.fetch { data in
            self.articles = data.compactMap { article in
                article.toViewModel()
            }.sorted{ $0.publishedAt > $1.publishedAt }
        }
    }
    
    func readArticle(_ url: String){
        guard let url = URL(string: url) else {
            return
        }
        openURL(url)
    }
}
