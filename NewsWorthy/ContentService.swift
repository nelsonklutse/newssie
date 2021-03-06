//
//  ContentService.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import Foundation

protocol ContentService {
    associatedtype Output
    func fetch(_ output: @escaping (Output?) -> Void)
}


protocol CacheService: ContentService {
    func save(objects: Output, _ completion: @escaping (_ error: Error?) -> Void)
}

protocol ContentResponse {
    associatedtype Output
    func getContent() -> Output
}

