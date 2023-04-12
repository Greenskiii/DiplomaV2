//
//  LoadingView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
            RoundedRectangle(cornerRadius: 5)
                .stroke()
                .foregroundColor(Color.gray)
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                    .scaleEffect(1.5)
                    .padding()
                Text("Loading...")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .foregroundColor(Color.white)
    }
}
