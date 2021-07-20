//
//  NewsArticle+CoreDataProperties.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 20/07/2021.
//
//

import Foundation
import CoreData


extension NewsArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticle> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }

    @NSManaged public var author: String?
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var imageSource: String?
    @NSManaged public var publishedAt: String?

}

extension NewsArticle : Identifiable {

}
