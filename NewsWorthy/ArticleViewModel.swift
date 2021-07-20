//
//  ArticleModel.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation


struct ArticleViewModel: Identifiable {
    var id = UUID()
    let url: String
    let source: String
    let author: String
    let title: String
    let description: String
    let imageSource: String
    let publishedAt: String
    //let content: String
}
