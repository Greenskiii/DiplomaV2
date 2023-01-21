//
//  AuthorizationModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 17.01.2023.
//

import SwiftUI
import Combine
import AuthenticationServices

final class AuthorizationModel {
    var subscriptions = Set<AnyCancellable>()
    @Published var nonce: String = ""
    @Published var state: Bool = false
    var timer = Timer()

    @Published var showError = false
    private var goToMainMenu: () -> Void

    let authManager: AuthManager
    var forgotPasswordViewModel: ForgotPasswordViewModel {
        ForgotPasswordViewModel(onResetPassword: onResetPassword)
    }
    
    private(set) lazy var onResetPassword = PassthroughSubject<String, Never>()


    private(set) lazy var onShowError = PassthroughSubject<Void, Never>()

    init(authManager: AuthManager, goToMainMenu: @escaping () -> Void) {
        self.goToMainMenu = goToMainMenu
        self.authManager = authManager
        
        self.authManager.$auth
            .sink { [weak self] auth in
                if auth {
                    self?.goToMainMenu()
                    self?.authManager.auth = false
                }
            }
            .store(in: &subscriptions)

        authManager.$nonce
            .assign(to: \.nonce, on: self)
            .store(in: &subscriptions)
        
        onResetPassword
            .sink { [weak self] email in
                self?.authManager.resetPassword(email: email)
            }
            .store(in: &subscriptions)

        onShowError
            .sink { [weak self] isError in
                var seconds: Double = 0.0
                self?.showError = true
                self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                            seconds += 1.0
                            if seconds == 5.0 {
                                self?.timer.invalidate()
                                DispatchQueue.main.async() {
                                    [weak self] in
                                    guard let strongSelf = self else { return }
                                    strongSelf.showError = false
                                }
                            }
                        })
            }
            .store(in: &subscriptions)

    }
    
    func loginWithApple() {
        authManager.loginWithApple()
    }
    
    func loginWithGoogle() {
        authManager.loginWithGoogle()
    }
    
    func loginWithEmail(email: String, password: String) {
        if email.contains("@") && email.contains(".com") && !password.isEmpty {
            authManager.loginWithEmail(email: email, password: password) { isError in
                if isError {
                    self.onShowError.send()
                } else {
                    self.goToMainMenu()
                }
            }
        } else {
            onShowError.send()
        }
    }
    
    func signUpWithEmail(email: String, password: String) {
        if email.contains("@") && email.contains(".com") && !password.isEmpty {
            authManager.signUpWithEmail(email: email, password: password) { isError in
                if isError {
                    self.onShowError.send()
                } else {
                    self.goToMainMenu()
                }
            }
        } else {
            onShowError.send()
        }
    }
}
