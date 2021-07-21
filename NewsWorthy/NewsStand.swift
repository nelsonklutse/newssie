//
//  NewsStand.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import SwiftUI

class NewsStand: ObservableObject {
    @Environment(\.openURL) var openURL
    
    private var newsProvider: NewsServiceComposite
    @Published var articles: [ArticleViewModel] = []
    
    init(provider: NewsServiceComposite) {
        self.newsProvider = provider
    }
    
    func getArticles(){
        self.newsProvider.fetch { data in
            if let data = data {
                self.articles = data.compactMap { article in
                    article.toViewModel()
                }.sorted{ $0.publishedAt > $1.publishedAt }
            }
            
        }
    }
    
    func readArticle(_ url: String){
        guard let url = URL(string: url) else {
            return
        }
        openURL(url)
    }
}
