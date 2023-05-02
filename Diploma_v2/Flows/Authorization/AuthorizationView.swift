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
    private enum Constants {
        static let rectangleHeight: CGFloat = 1
        static let topPadding: CGFloat = 10
        static let bottomSheetOffset: CGFloat = 100
        static let horizontalPadding: CGFloat = 40
        
        enum Buttons {
            static let forgotButtonPadding: CGFloat = 19
            static let buttonCornerRadius: CGFloat = 4
            static let height: CGFloat = 40
            static let imageHeight: CGFloat = 30
            static let imageWidth: CGFloat = 30
            static let imagePadding: CGFloat = 8
            static let horizontalPadding: CGFloat = 4
        }
        enum Logo {
            static let titleImageHeight: CGFloat = 80
            static let titleImageWidth: CGFloat = 160
            static let titleImageOffset: CGFloat = -75
            static let circleHeight: CGFloat = 130
            static let padding: CGFloat = 20
            static let imageHeight: CGFloat = 100
            static let imageWidth: CGFloat = 100
        }
        enum Picker {
            static let height: CGFloat = 40
            static let padding: CGFloat = 20
        }
        enum TextField {
            static let verticalPadding: CGFloat = 10
        }
        
    }
    
    @ObservedObject var viewModel: AuthorizationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    createLogo()
                    createTextFields()
                    createButtonsView()
                    
                    HStack {
                        Rectangle()
                            .frame(height: Constants.rectangleHeight)
                        Text(NSLocalizedString("OR", comment: "Auth view"))
                        Rectangle()
                            .frame(height: Constants.rectangleHeight)
                    }
                    .foregroundColor(Color("Royalblue"))
                    .padding(.top, Constants.topPadding)
                    
                    createAlternativeAuthorizationView()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, Constants.horizontalPadding)
                
                if viewModel.showError {
                    ErrorView()
                        .foregroundColor(.black)
                        .animation(.easeInOut(duration: 1),
                                   value: viewModel.showError)
                }
                
                BottomSheetView(
                    maxHeight: geometry.size.height * 0.95,
                    isOpen: $viewModel.forgotPasswordIsOpen) {
                        ForgotPasswordView(viewModel: viewModel.forgotPasswordViewModel)
                    }
                    .shadow(color: .gray, radius: 3, x: 2, y: 0)
                    .offset(y: Constants.bottomSheetOffset)
                
            }
            
        }
    }
    
    private func createLogo() -> some View {
        ZStack {
            Image("Title")
                .resizable()
                .frame(width: Constants.Logo.titleImageWidth,
                       height: Constants.Logo.titleImageHeight)
                .offset(y: Constants.Logo.titleImageOffset)
            Circle()
                .foregroundColor(Color("TropicalBlue"))
                .frame(height: Constants.Logo.circleHeight)
            Image("AuthorizationCat")
                .resizable()
                .frame(width: Constants.Logo.imageWidth,
                       height: Constants.Logo.imageHeight)
        }
        .padding(.bottom, Constants.Logo.padding)
    }
    
    private func createTextFields() -> some View {
        VStack {
            SegmentedPicker(items: [NSLocalizedString("LOGIN", comment: "Auth view"), NSLocalizedString("SIGNUP", comment: "Auth view")], selection: $viewModel.selection)
                .frame(height: Constants.Picker.height)
                .padding(.bottom, Constants.Picker.padding)
            
            TextField(NSLocalizedString("EMAIL_ADDRESS", comment: "Auth view"), text: $viewModel.email)
                .padding(.vertical, Constants.TextField.verticalPadding)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
            
            SecureTextField(NSLocalizedString("PASSWORD", comment: "Auth view"), text: $viewModel.password)
                .padding(.bottom, Constants.TextField.verticalPadding)
            
            if viewModel.selection == 1 {
                SecureTextField(NSLocalizedString("CONFIRM_PASSWORD", comment: "Auth view"), text: $viewModel.passwordDuplicate)
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
                        Text(NSLocalizedString("FORGOT_PASSWORD", comment: "Auth view"))
                            .foregroundColor(Color("Royalblue"))
                            .font(Font.subheadline)
                        
                        Spacer()
                    }
                    .padding(.bottom, Constants.Buttons.forgotButtonPadding)
                }
                .animation(.easeInOut(duration: 0.3))
                .transition(.move(edge: .trailing))
            }
            
            Button {
                switch viewModel.selection {
                case 0:
                    viewModel.loginWithEmail(email: viewModel.email,
                                             password: viewModel.password)
                case 1:
                    viewModel.signUpWithEmail(email: viewModel.email,
                                             password: viewModel.password)
                default:
                    break
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.Buttons.buttonCornerRadius)
                        .foregroundColor(Color("BlueShark"))
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    
                    Text(viewModel.selection == 0 ? NSLocalizedString("LOGIN", comment: "Auth view") : NSLocalizedString("SIGNUP", comment: "Auth view"))
                        .foregroundColor(.white)
                }
                .frame(height: Constants.Buttons.height)
                .padding(.top, Constants.topPadding)
            }
        }
    }
    
    private func createAlternativeAuthorizationView() -> some View {
        HStack {
            Button {
                viewModel.onLoginWithGoogle.send()
            } label: {
                Image("googleLogo")
                    .resizable()
                    .frame(width: Constants.Buttons.imageWidth,
                           height: Constants.Buttons.imageHeight)
                    .padding(Constants.Buttons.imagePadding)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.Buttons.buttonCornerRadius)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    )
            }
            .padding(.horizontal, Constants.Buttons.horizontalPadding)
            
            Button {
                viewModel.onLoginWithApple.send()
            } label: {
                Image("appleLogo")
                    .resizable()
                    .frame(width: Constants.Buttons.imageWidth,
                           height: Constants.Buttons.imageHeight)
                    .padding(Constants.Buttons.imagePadding)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.Buttons.buttonCornerRadius)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    )
            }
            .padding(.horizontal, Constants.Buttons.horizontalPadding)
        }
        .padding(.top, Constants.topPadding)
    }
} 
