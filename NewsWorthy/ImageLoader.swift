//
//  ImageLoader.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 20/07/2021.
//

import Foundation


class ImageLoader: ObservableObject {
    @Published var imgData = Data()
    
    init(imageURL: String) {
            let cache = URLCache.shared
            let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
            if let data = cache.cachedResponse(for: request)?.data {
                self.imgData = data
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response {
                    let cachedData = CachedURLResponse(response: response, data: data)
                                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.imgData = data
                        }
                    }
                }).resume()
            }
        }
}
