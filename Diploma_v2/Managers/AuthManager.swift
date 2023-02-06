//
//  AuthManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import Combine
import CryptoKit
import AuthenticationServices
import Foundation
import GoogleSignIn

final class AuthManager: NSObject, ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    @AppStorage("log_status") var logStatus = false
    
    @Published var nonce: String = ""
    @Published var auth: Bool = false

    let firebaseAuth = Auth.auth()
    
    func loginWithApple() {
        self.nonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = screen.windows.first?.rootViewController else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: root) { signResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = signResult?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            self.googleAuthenticate(credential: credential)
        }
    }

    func loginWithEmail(email: String, password: String, completion: @escaping (Bool) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed due to error:", err)
                completion(true)
                return
            }
            completion(false)
            print("Successfully logged in with ID: \(result?.user.uid ?? "")")
            self.logStatus = true
        }
    }

    func signUpWithEmail(email: String, password: String, completion: @escaping (Bool) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password, completion: { result, err in
            if let err = err {
                print("Failed due to error:", err)
                completion(true)
                return
            }
            completion(false)
            print("Successfully created account with ID: \(result?.user.uid ?? "")")
            self.logStatus = true
        })
    }

    func logOut() {
        do {
            try firebaseAuth.signOut()
            logStatus = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(email: String) {
        firebaseAuth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserInfo() -> User? {
        guard let authUser = Auth.auth().currentUser else {
            return nil
        }
        
        return User(
            name: authUser.displayName ?? "User",
            imageUrl: authUser.photoURL?.absoluteString ?? "",
            uid: authUser.uid)
    }
}

// MARK: - Apple
extension AuthManager {
    private func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) {
        guard let token = credential.identityToken,
              let tokenString = String(data: token, encoding: .utf8) else {
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: self.nonce
          )
        
        firebaseAuth.signIn(with: firebaseCredential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.auth = true
            print("Success")
            self.logStatus = true
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                                    print("error")
                                    return
                                }
        self.appleAuthenticate(credential: credential)
    }
}

// MARK: - Google
extension AuthManager {
    
    private func googleAuthenticate(credential: AuthCredential) {
        firebaseAuth.signIn(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.auth = true
            print("Success")
            self.logStatus = true
        }
    }
}
