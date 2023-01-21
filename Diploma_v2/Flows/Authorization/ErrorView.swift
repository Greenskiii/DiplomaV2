//
//  ErrorView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import SwiftUI

struct ErrorView: View {
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
                Text("Something went wrong, please try again")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
