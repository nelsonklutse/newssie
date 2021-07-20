//
//  LocalNewsService.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation
import CoreData


class LocalNewsService: CacheService {
    
    var persistenceController: PersistenceController
    
    typealias Output = [Article]
    
    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
    
    
    func fetch(_ output: @escaping (Output?) -> Void) {
        
        let articlesFetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        
        // Get the shared NSManagedObjectContext to perform fetch
        self.persistenceController.container.viewContext.perform {
            do {
                // Execute request
                let data = try articlesFetchRequest.execute()
                (data.count > 0) ? output(self.transformCoreDataObjects(data)) : output(nil)
            }catch {
                output(nil)
            }
        }
    }
    
    func save(objects: Output, _ completion: @escaping (_ error: Error?) -> Void) {
        let viewContext = self.persistenceController.container.viewContext
        objects.forEach { (article) in
            let item = NewsArticle(context: viewContext)
            item.url = article.url
            item.source = article.source.name
            item.imageSource = article.urlToImage
            item.title = article.title
            item.author = article.author
            item.articleDescription = article.description
            item.publishedAt = article.publishedAt
            
            do {
                try viewContext.save()
                completion(nil)
            }catch {
                let nsError = error as NSError
                
                // Useful only for development
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func transformCoreDataObjects(_ data: [NewsArticle]) -> [Article]{
        return data.compactMap { newsItem in
                        Article(
                            url: newsItem.url!,
                            source: Source(name: newsItem.source!),
                            author: newsItem.author!,
                            title: newsItem.title!,
                            description: newsItem.articleDescription!,
                            urlToImage: newsItem.imageSource!,
                            publishedAt: newsItem.publishedAt!
                    )
        }
        
        //return articles
    }
}
