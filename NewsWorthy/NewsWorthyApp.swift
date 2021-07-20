//
//  NewsWorthyApp.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 19/07/2021.
//

import SwiftUI

@main
struct NewsWorthyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(newsStand: NewsStand())
        }
    }
}
