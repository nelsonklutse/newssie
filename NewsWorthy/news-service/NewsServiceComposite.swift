//
//  NewsServiceComposer.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation

class NewsServiceComposite: ContentService {
    
    typealias Output = [Article]
    
    private var onlineService: OnlineNewsService
    private var localService: LocalNewsService
    
    init(onlineService: OnlineNewsService = OnlineNewsService(), localService: LocalNewsService = LocalNewsService()) {
        self.onlineService = onlineService
        self.localService = localService
    }
    
    func fetch(_ output: @escaping ([Article]) -> Void) {
        onlineService.fetch { articles in
            output(articles)
        }
    }
}
