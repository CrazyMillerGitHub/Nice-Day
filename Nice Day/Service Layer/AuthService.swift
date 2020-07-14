//
//  AuthService.swift
//  Nice Day
//
//  Created by Михаил Борисов on 09.01.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit
import FirebaseFirestore
import AuthenticationServices

struct AuthUser {
    let firstName: String
    let lastName: String
    let emailAdress: String
}

/// Singleton Class
class AuthManager {
    
    // create shared
    static var shared = AuthService()
    
    private init() {
        
    }
    
}

class AuthService: NSObject {
    
    /// Check if user info is valid to use
    /// - Parameters:
    ///   - user: User Structure which contains first and last name
    ///   - email: user email
    ///   - password: password email
    ///   - completeion: completion handler that should be returned
    func signUp(_ user: (firstName: String, lastName: String),
                _ email: String,
                password: String,
                completion: @escaping (_ error: String?, _ result: AuthUser?) -> Void ) {
        
        // check if data is valid
//        guard (isPasswordValid(password) && isEmailValidate(email)) else {
//            // completion handler when invalid
//            completeion("Incorrect Values", nil)
//            return
//        }
        
        // try to create new user using our email and password
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            // check if our ouptup error
            if let error = error {
                completion(error.localizedDescription, nil)
            } else {
                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    
                    currentUser.displayName = [user.firstName, user.lastName].joined(separator: " ")
                    
                    currentUser.commitChanges { err in
                        if let err = err {
                            completion(err.localizedDescription, nil)
                        } else {
                            let dataBase = Firestore.firestore()
                            // add values to our collection
                            dataBase.collection("users").document(Auth.auth().currentUser!.uid).setData(
                                ["lastName" : user.lastName,
                                 "firstName": user.firstName,
                                 "favourite": [],
                                 "friends": []]
                            )
                            completion(nil, AuthUser(firstName: user.firstName, lastName: user.lastName, emailAdress: email))
                        }
                        
                    }
                }
            }
            // if all currectly done we callback completionhandler with userData
        }
    }

    /// sign in function
    /// - Parameters:
    ///   - email: user email
    ///   - password: user paasword
    ///   - completion: completion handler
    func signIn(_ email: String,
                _ password: String,
                completion: @escaping (_ error: String?, _ result: AuthUser?) -> Void ) {
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            
            if let error = error {
                completion(error.localizedDescription, nil)
                return
            }
            
            if let currentUser = Auth.auth().currentUser {
                guard let userInfo = currentUser.displayName?.split(separator: " ").map(String.init) else {
                    completion("User display name is nil", nil)
                    return
                }
                
                UserDefaults.standard.setValue(userInfo.joined(separator: " "), forKey: "userName")
                completion(nil , AuthUser(firstName: userInfo.first!, lastName: userInfo.last!, emailAdress: currentUser.email!))
            }
        }
    }

    func appleSignIn(providerID: String, idTokenString: String, nonce: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        
    }
    /// check if user email is valid
    /// - Parameter email: emailTextField text
    private func isEmailValidate(_ email:String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: email) && !(email == "")

    }
    
    /// ckeck if user password valid
    /// - Parameter password: passwordTextField text
    private func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password) && (password == "")
    }

}

extension AuthService {

}
