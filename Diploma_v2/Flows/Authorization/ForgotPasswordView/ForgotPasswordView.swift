//
//  ForgotPasswordView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 19.01.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: ForgotPasswordViewModel

    var body: some View {
        ZStack {
            Color("TropicalBlue")
                .ignoresSafeArea()
            
            VStack {
                Image("ForgotPasswordCat")
                    .resizable()
                    .frame(width: 150, height: 150)

                Text("Forgot your password?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                Text("Enter your email address to \nretrieve your password")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding(.top, -10)

                TextField("Email Address", text: $viewModel.email)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button {
                    viewModel.onResetPassword.send(viewModel.email)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("BlueShark"))
                            .frame(height: 50)
                            .padding(.horizontal, 40)

                        Text("Send")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}
