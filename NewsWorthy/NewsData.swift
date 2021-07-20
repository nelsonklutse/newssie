//
//  NewsData.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation


struct NewsData: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let url: String
    let source: Source
    let author: String
    let title: String
    let description: String
    let urlToImage: String
    let publishedAt: String
    
    
    func toDictionary() -> Any {
        return [
            "title": title,
            "url": url,
            "source": source.name,
            "description": description
        ]
    }
    
    func toViewModel() -> ArticleViewModel {
//        let dateFormatter = ISO8601DateFormatter()
//        dateFormatter.formatOptions = .withInternetDateTime
//        let inputDate = dateFormatter.date(from: self.publishedAt)!
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let oldDate = olDateFormatter.date(from: self.publishedAt)

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd"

        let formattedDate = convertDateFormatter.string(from: oldDate!)
    
        
        return ArticleViewModel(id: UUID(),
                                url: self.url,
                                source: self.source.name,
                                author: self.author,
                                title: self.title,
                                description: self.description,
                                imageSource: self.urlToImage,
                                publishedAt: formattedDate
                            )
    }
}

struct Source: Decodable {
    let name: String
}
