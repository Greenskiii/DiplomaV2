//
//  ImageView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 02.02.2023.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    let isCircle: Bool

    init(withURL url: String, isCircle: Bool = false) {
        imageLoader = ImageLoader(urlString: url)
        self.isCircle = isCircle
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onReceive(imageLoader.didChange) { data in
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
    }
}
