//
//  AuthorizationViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI
import Combine
import AuthenticationServices

final class AuthorizationViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()

    let model: AuthorizationModel
    @Published var showError = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordDuplicate: String = ""
    @Published var selection = 0
    @Published var nonce: String = ""
    @Published var forgotPasswordIsOpen: Bool = false
    var forgotPasswordViewModel: ForgotPasswordViewModel {
        model.forgotPasswordViewModel
    }
    
    init(model: AuthorizationModel) {
        self.model = model
        model.$showError
            .assign(to: \.showError, on: self)
            .store(in: &subscriptions)

        model.$nonce
            .assign(to: \.nonce, on: self)
            .store(in: &subscriptions)

    }
    
    func loginWithApple() {
        model.loginWithApple()
    }
    
    func loginWithEmail() {
        model.loginWithEmail(email: email, password: password)
    }
    
    func loginWithGoogle() {
        model.loginWithGoogle()
    }
    
    func signUpWithEmail() {
        if password == passwordDuplicate {
            model.signUpWithEmail(email: email, password: password)
        } else {
            
        }
    }
}
