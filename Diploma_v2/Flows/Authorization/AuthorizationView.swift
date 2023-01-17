//
//  AuthorizationView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct AuthorizationView: View {
    @ObservedObject var viewModel: AuthorizationViewModel = AuthorizationViewModel()
    @EnvironmentObject var coordinator: Coordinator<AuthorizationRouter>
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100)
            createLogo()
            createTextFields()
            createButtonsView()

            HStack {
                Rectangle()
                    .frame(height: 1)
                Text("Or")
                Rectangle()
                    .frame(height: 1)
            }
            .foregroundColor(Color("Royalblue"))
            .padding(.top, 10)
            .padding(.horizontal, 40)

            createAlternativeAuthorizationView()

            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    private func createLogo() -> some View {
        ZStack {
            Image("Title")
                .resizable()
                .frame(width: 160, height: 80)
                .offset(y: -75)
            Circle()
                .foregroundColor(Color("TropicalBlue"))
                .frame(height: 130)
            Image("AuthorizationCat")
                .resizable()
                .frame(width: 100, height: 100)
        }
        .padding(.bottom, 20)
    }

    private func createTextFields() -> some View {
        VStack {
            SegmentedPicker(items: ["Login", "SignUp"], selection: $viewModel.selection)
                .frame(height: 40)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

            TextField("Email Address", text: $viewModel.email)
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)

            TextField("Password", text: $viewModel.password)
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)

            if viewModel.selection == 1 {
                TextField("Confirm password", text: $viewModel.password)
                    .padding(.horizontal, 40)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.move(edge: .leading))
            }
        }
    }

    private func createButtonsView() -> some View {
        VStack {
            if viewModel.selection == 0 {
                Button {
                    
                } label: {
                    HStack {
                        Text("Forgot Password?")
                            .foregroundColor(Color("Royalblue"))
                            .font(Font.subheadline)
  
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 16)
                    
                }
                .animation(.easeInOut(duration: 0.5))
                .transition(.move(edge: .trailing))
            }

            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(
                            gradient: .init(colors: [Color("Royalblue"), Color("TropicalBlue")]),
                            startPoint: .init(x: 0, y: 0.5),
                            endPoint: .init(x: 0.6, y: 0.5)
                        ))
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    Text(viewModel.selection == 0 ? "Login" : "SignUp")
                        .foregroundColor(.white)
                }
                .frame(height: 40)
                .padding(.horizontal, 40)
                .padding(.top, 10)
            }
        }
    }

    private func createAlternativeAuthorizationView() -> some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .frame(width: 45, height: 45)
                Image("googleLogo")
                    .resizable()
                    .frame(width: 30, height: 30)
            }

            ZStack{
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .frame(width: 45, height: 45)
                Image("appleLogo")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.top, 10)
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
