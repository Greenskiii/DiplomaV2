//
//  ErrorView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import SwiftUI

struct ErrorView: View {
    let errorText: String

    init(errorText: String = NSLocalizedString("BASE_ERROR", comment: "Error")) {
        self.errorText = errorText
    }

    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
            RoundedRectangle(cornerRadius: 16)
                .stroke()
                .foregroundColor(.gray)
            VStack {
                Image("ErrorCat")
                    .resizable()
                    .frame(width: 150, height: 85)
                    .padding(.bottom, 10)
                Text(errorText)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
            }
        }
    }
}
