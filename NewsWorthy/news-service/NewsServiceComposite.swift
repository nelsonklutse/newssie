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
    
    func fetch(_ output: @escaping (Output?) -> Void) {
        // First fetch locally
        localService.fetch { [weak self] response in
            
            guard let data = response else {
                
                self?.onlineService.fetch { [weak self] articles in
                    
                    self?.localService.save(objects: articles!) { (done) in
                        
                        if done {
                            
                            self?.localService.fetch({ articles in
                                output(articles)
                            })
                        }
                    }
                }
                return
            }
            
            output(data)
        }
    }
}
