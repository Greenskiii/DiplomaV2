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
    @Published var nonce: String = ""
    @Published var state: Bool = false
    @Published var showError = false

    var timer = Timer()
    var subscriptions = Set<AnyCancellable>()

    private var onGoToRootTabView: PassthroughSubject<Void, Never>
    private(set) lazy var onLoginWithGoogle = PassthroughSubject<Void, Never>()
    private(set) lazy var onLoginWithApple = PassthroughSubject<Void, Never>()
    private(set) lazy var onResetPassword = PassthroughSubject<String, Never>()
    private(set) lazy var onShowError = PassthroughSubject<Void, Never>()

    let authManager: AuthManager
    let dataManager: DataManager

    var forgotPasswordViewModel: ForgotPasswordViewModel {
        ForgotPasswordViewModel(onResetPassword: onResetPassword)
    }

    init(
        authManager: AuthManager,
         dataManager: DataManager,
         onGoToRootTabView: PassthroughSubject<Void, Never>
    ) {
        self.onGoToRootTabView = onGoToRootTabView
        self.authManager = authManager
        self.dataManager = dataManager

        self.authManager.$auth
            .sink { [weak self] auth in
                if auth {
                    self?.onGoToRootTabView.send()
                    self?.authManager.auth = false
                }
            }
            .store(in: &subscriptions)

        authManager.$nonce
            .assign(to: \.nonce, on: self)
            .store(in: &subscriptions)

        onLoginWithApple
            .sink { [weak self] _ in
                self?.authManager.loginWithApple()
            }
            .store(in: &subscriptions)

        onLoginWithGoogle
            .sink { [weak self] _ in
                self?.authManager.loginWithGoogle()
            }
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
                self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    seconds += 1.0
                    if seconds == 2.0 {
                        self?.timer.invalidate()
                        DispatchQueue.main.async() {
                            [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.showError = false
                        }
                    }
                }
            }
            .store(in: &subscriptions)
    }

    func loginWithEmail(email: String, password: String) {
        if email.contains("@") && email.contains(".") && !password.isEmpty {
            authManager.loginWithEmail(email: email, password: password) { isError in
                if isError {
                    self.onShowError.send()
                } else {
                    self.dataManager.setHousesId()
                    self.onGoToRootTabView.send()
                    self.dataManager.checkFCMToken()
                }
            }
        } else {
            onShowError.send()
        }
    }

    func signUpWithEmail(email: String, password: String) {
        if email.contains("@") && email.contains(".") && !password.isEmpty {
            authManager.signUpWithEmail(email: email, password: password) { isError in
                if isError {
                    self.onShowError.send()
                } else {
                    self.dataManager.setHousesId()
                    self.onGoToRootTabView.send()
                    self.dataManager.checkFCMToken()
                }
            }
        } else {
            onShowError.send()
        }
    }
}
