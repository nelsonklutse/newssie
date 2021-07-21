//
//  NewsServiceComposer.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation

class NewsServiceComposite {
    
    private var onlineService: OnlineNewsService<NewsData>
    private var localService: LocalNewsService
    
    init(onlineService: OnlineNewsService<NewsData>,
         localService: LocalNewsService = LocalNewsService()
    ) {
        self.onlineService = onlineService
        self.localService = localService
    }
    
    func fetch(_ output: @escaping ([Article]?) -> Void) {
        // First fetch locally
        localService.fetch { [weak self] response in
            
            if let data = response, data.count > 0 {
                output(data)
                return
            }
            
            self?.onlineService.fetch { [weak self] newsData in
                
                self?.localService.save(objects: newsData!.articles) { error  in
                    
                    if error == nil {
                        
                        self?.localService.fetch { articles in
                            output(articles)
                        }
                    }
                }
            }
        }
    }
}
