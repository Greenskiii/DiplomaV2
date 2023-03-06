//
//  ForgotPasswordViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 19.01.2023.
//

import SwiftUI
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""

    private(set) lazy var onResetPassword = PassthroughSubject<String, Never>()

    init(onResetPassword: PassthroughSubject<String, Never>) {
        self.onResetPassword = onResetPassword
    }
}
