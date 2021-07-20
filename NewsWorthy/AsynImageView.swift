//
//  AsynImageView.swift
//  NewsWorthy
//
//  Created by Nelson Klutse on 20/07/2021.
//

import SwiftUI

struct AsynImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    init(_ url: String) {
            imageLoader = ImageLoader(imageURL: url)
        }
    
    var body: some View {
              Image(uiImage: UIImage(data: self.imageLoader.imgData) ?? UIImage())
                .resizable()
                .frame(width: 60, height: 60)
                .clipped()
                .aspectRatio(contentMode: .fit)
                
        }
}
