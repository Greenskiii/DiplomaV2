//
//  AuthorizationViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI

final class AuthorizationViewModel: ObservableObject {
    @Published var state: Bool = false

    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var selection = 0
    
    @Published var showError = false

    let authManager = AuthManager()
    
    func login() {
        
        authManager.signInWithEmail(email: email, password: password)
        
    }
    
}
