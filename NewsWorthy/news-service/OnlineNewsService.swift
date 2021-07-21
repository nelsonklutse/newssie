//
//  OnlineNewsService.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation
import Combine


enum NetworkError: LocalizedError {
    case statusCode
    case BadRequest
}

enum DataError: LocalizedError {
    case badFormat
}

class OnlineNewsService<T: Decodable>: ContentService {
    
    typealias Output = T
    
    private var apiClient: ApiClient
    private var cancellable: AnyCancellable?
    
    init(networkClient: ApiClient = ApiClient.shared) {
        self.apiClient = networkClient
    }
    
        
    func fetch(_ output: @escaping (Output?) -> Void) {
        var serviceUrl = URLComponents(string: "https://newsapi.org/v2/everything")
        serviceUrl?.query = "q=Ghana&from=2021-07-01&sortBy=popularity&pageSize=20"
        var newsRequest = URLRequest(url: serviceUrl!.url!)
        newsRequest.setValue("9e2d6908738d4a2fabd091173c5c7877", forHTTPHeaderField: "x-api-key")
        
        self.cancellable = apiClient.dataRequest(newsRequest, object: Output.self) { data in
            output(data)
        } as? AnyCancellable
    }
    
}
