//
//  ForgotPasswordView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 19.01.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    private enum Constants {
        static let imageHeight: CGFloat = 150
        static let imageWidth: CGFloat = 150
        
        enum Text {
            static let titlePadding: CGFloat = 20
            static let mainTextPadding: CGFloat = -10
        }
        enum TextField {
            static let horizontalPadding: CGFloat = 40
            static let verticalPadding: CGFloat = 10
        }
        enum Button {
            static let cornerRadius: CGFloat = 8
            static let height: CGFloat = 50
            static let horizontalPadding: CGFloat = 40
            static let bottomPadding: CGFloat = 50
        }
    }
    
    @ObservedObject var viewModel: ForgotPasswordViewModel
    
    var body: some View {
        ZStack {
            Color("TropicalBlue")
                .ignoresSafeArea()
            
            VStack {
                Image("ForgotPasswordCat")
                    .resizable()
                    .frame(width: Constants.imageWidth,
                           height: Constants.imageHeight)
                
                Text(NSLocalizedString("FORGOT_PASSWORD_VIEW", comment: "Auth view"))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, Constants.Text.titlePadding)
                
                Text(NSLocalizedString("ENTER_EMAIL", comment: "Auth view"))
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding(.top, Constants.Text.mainTextPadding)
                
                TextField(NSLocalizedString("EMAIL_ADDRESS", comment: "Auth view"), text: $viewModel.email)
                    .padding(.horizontal, Constants.TextField.horizontalPadding)
                    .padding(.vertical, Constants.TextField.verticalPadding)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    viewModel.onResetPassword.send(viewModel.email)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.Button.cornerRadius)
                            .foregroundColor(Color("BlueShark"))
                            .frame(height: Constants.Button.height)
                            .padding(.horizontal, Constants.Button.horizontalPadding)
                        
                        Text(NSLocalizedString("SEND", comment: "Action"))
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, Constants.Button.bottomPadding)
            }
        }
    }
}
