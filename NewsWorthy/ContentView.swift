//
//  ContentView.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var newsStand: NewsStand
    
    var body: some View {
        NavigationView {
            List {
                ForEach(newsStand.articles){ article in
                    Link(destination: URL(string: article.url)!, label: {
                        NewsView(article: article)
                    })
                }
            }
            .navigationBarTitle("Newssie")
        }
        
        .onAppear {
            newsStand.getArticles()
        }
    }
}


struct NewsView: View {
    var article: ArticleViewModel
    
    var body: some View {
        HStack {
            AsynImageView(article.imageSource)
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    //.bold()
                    
                VStack(alignment: .leading){
                    Text("Source: \(article.source)")
                        .font(.caption2)
                    Text("Published: \(article.publishedAt)")
                        .font(.caption2)
                }
            }
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    let newsStand = NewsStand()
//    static var previews: some View {
//        ContentView(newsStand: NewsStand())
//    }
//}
