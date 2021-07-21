//
//  ApiClient.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 21/07/2021.
//

import Foundation

class ApiClient {
    static let shared = ApiClient()
    
    private var networkClient: URLSession
    var host: String?
    var path: String?
    
    
    init(client: URLSession = URLSession(configuration: .default)) {
        self.networkClient = client
    }
    
    func dataRequest<T: Decodable>(_ request: URLRequest,
                                   object: T.Type,
                                   output: @escaping (T) -> Void) -> Any {
        
        return networkClient.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(output.response)
                    throw NetworkError.statusCode
                }
                return output.data
            }
            .decode(type: object, decoder: JSONDecoder())
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
                output(newsData)
            })
    }
    
    
    private func handleServerError(_ res: URLResponse?){
        debugPrint("There was a server error:: \(String(describing: res))")
    }
    
}
