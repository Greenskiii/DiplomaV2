//
//  ImageView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 02.02.2023.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        if let image = urlImageModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
        }
        
    }
    
    static var defaultImage = UIImage(systemName: "exclamationmark.triangle")
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(urlString: nil)
    }
}
