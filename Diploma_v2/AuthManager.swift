//
//  AuthManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI
import FirebaseAuth

enum AuthError {
    case error
    case none
}

final class AuthManager {
    
    func signInWithApple() {
        
    }
    
    func signInWithGoogle() {
        
    }
    
    func signInWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
                    if let err = err {
                        print("Failed due to error:", err)
                        return
                    }
                    print("Successfully logged in with ID: \(result?.user.uid ?? "")")
                }
    }
    
    func registration(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, err in
                    if let err = err {
                        print("Failed due to error:", err)
                        return
                    }
                    print("Successfully created account with ID: \(result?.user.uid ?? "")")
                })
    }
}
