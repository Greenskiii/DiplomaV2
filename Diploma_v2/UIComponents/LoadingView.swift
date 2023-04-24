//
//  LoadingView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import SwiftUI

struct LoadingView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 5
        static let scaleEffect: CGFloat = 1.5
        static let width: CGFloat = 155
        static let height: CGFloat = 175
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .circular))
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke()
                .foregroundColor(Color.gray)
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                    .scaleEffect(Constants.scaleEffect)
                    .padding()
                Text(NSLocalizedString("LOADING", comment: "Loading"))
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .frame(width: Constants.width,
               height: Constants.height)
        .foregroundColor(Color.white)
    }
}
