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

class OnlineNewsService: ContentService {
    
    typealias Output = [Article]
    
    private let kBaseURL = "https://newsapi.org/v2/everything"
    private let kApiToken = "9e2d6908738d4a2fabd091173c5c7877"
    private var newsClient: URLSession
    
    private var cancellable: AnyCancellable?
    
    
    init(client: URLSession = URLSession(configuration: .default)) {
        self.newsClient = client
    }
    
    
    func fetch(_ output: @escaping (Output?) -> Void) {
        var serviceUrl = URLComponents(string: kBaseURL)
        serviceUrl?.query = "q=Ghana&from=2021-07-01&sortBy=popularity&pageSize=20&apiKey=\(kApiToken)"
        
        guard let url = serviceUrl?.url else {
            return
          }
        
        self.cancellable = newsClient.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(output.response)
                    throw NetworkError.statusCode
                }
                return output.data
            }
            .decode(type: NewsData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        debugPrint("finished")
                        break
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                        break
                }
            }, receiveValue: { newsData in
                output(newsData.articles)
            })
        
        //self.cancellable?.cancel()
    }
    
    func save(objects: Output, _ completion: @escaping (Bool) -> Void) {}
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?){
        
            if let error = error {
                debugPrint("Error with request::\n \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response)
                return
            }
            
            // We got data
            _ = self.handlePayloadReceived(data)
    }
    
    private func handleServerError(_ res: URLResponse?){
        debugPrint("There was a server error:: \(String(describing: res))")
    }
    
    private func handlePayloadReceived(_ payload: Data?) ->  Any {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: payload!)
            return decodedData.articles
        }catch {
            debugPrint(error)
        }
        
        return Array<Article>()
        
    }
}
