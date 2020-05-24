//
//  SignInWithAppleToFirebase.swift
//  LoginWithAppleFirebaseSwiftUI
//
//  Created by Joseph Hinkle on 12/15/19.
//  Copyright © 2019 Joseph Hinkle. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

enum SignInWithAppleToFirebaseResponse {
    case success
    case error
}

class SignInWithAppleDelegates: NSObject {
    
    private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> Void)?
    private weak var window: UIWindow!
    private var currentNonce: String? // Unhashed nonce.
    
    init(window: UIWindow?, currentNonce: String, onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> Void)? = nil) {
        self.window = window
        self.currentNonce = currentNonce
        self.onLoginEvent = onLoginEvent
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    func firebaseLogin(credential: ASAuthorizationAppleIDCredential) {
        // 3
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = credential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error.localizedDescription)
                return
            }
        }

    }

    func checkUser() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print(user?.email)
        }
    }

    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {

        let userData = UserData(email: credential.email!,
                                name: credential.fullName!,
                                identifier: credential.user)

        // 2
        let keychain = UserDataKeychain()
        do {
            try keychain.store(userData)
        } catch {
            
        }
        
        // 3
        firebaseLogin(credential: credential)
    }

    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        self.firebaseLogin(credential: credential)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if appleIdCredential.email != nil, appleIdCredential.fullName != nil {
                registerNewAccount(credential: appleIdCredential)
            } else {
                signInWithExistingAccount(credential: appleIdCredential)
            }
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
