//
//  AuthorizationView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI
import GoogleSignIn
import _AuthenticationServices_SwiftUI
import Combine

struct AuthorizationView: View {
    @ObservedObject var viewModel: AuthorizationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)
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
                
                if viewModel.showError {
                    ErrorView()
                        .frame(width: 225, height: 255)
                        .foregroundColor(.black)
                }
                
                BottomSheetView(
                    maxHeight: geometry.size.height * 0.95,
                    isOpen: $viewModel.forgotPasswordIsOpen) {
                    ForgotPasswordView(viewModel: viewModel.forgotPasswordViewModel)
                }
                    .offset(y: 100)
            }
        }
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

            SecureTextField("Password", text: $viewModel.password)
                .padding(.horizontal, 40)
                .padding(.bottom, 10)

            if viewModel.selection == 1 {
                SecureTextField("Confirm password", text: $viewModel.passwordDuplicate)
                    .padding(.horizontal, 40)
                    .animation(.easeInOut(duration: 0.3))
                    .transition(.move(edge: .leading))
            }
        }
    }

    private func createButtonsView() -> some View {
        VStack {
            if viewModel.selection == 0 {
                Button {
                    viewModel.forgotPasswordIsOpen = true
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
                .animation(.easeInOut(duration: 0.3))
                .transition(.move(edge: .trailing))
            }

            Button {
                switch viewModel.selection {
                case 0:
                    viewModel.loginWithEmail()
                case 1:
                    viewModel.signUpWithEmail()
                default:
                    break
                }
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
            Button {
                viewModel.loginWithGoogle()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                        .frame(width: 45, height: 45)
                    Image("googleLogo")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }


            
            Button {
                viewModel.loginWithApple()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    Image("appleLogo")
                        .resizable()
                        .frame(width: 30, height: 30)
            }
            }
        }
        .padding(.top, 10)
    }
}
