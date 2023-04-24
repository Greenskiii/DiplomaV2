//
//  ErrorView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import SwiftUI

struct ErrorView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let imageHeight: CGFloat = 85
        static let imageWidth: CGFloat = 150
        static let padding: CGFloat = 10
        static let height: CGFloat = 225
        static let width: CGFloat = 225
    }
    
    let errorText: String
    
    init(errorText: String = NSLocalizedString("BASE_ERROR", comment: "Error")) {
        self.errorText = errorText
    }

    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .circular))
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke()
                .foregroundColor(.gray)
            VStack {
                Image("ErrorCat")
                    .resizable()
                    .frame(width: Constants.imageWidth,
                           height: Constants.imageHeight)
                    .padding(.bottom, Constants.padding)
                Text(errorText)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Constants.padding)
            }
        }
        .frame(width: Constants.width,
               height: Constants.height)
    }
}
