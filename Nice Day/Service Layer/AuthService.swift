//
//  AuthService.swift
//  Nice Day
//
//  Created by Михаил Борисов on 09.01.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

struct AuthUser {
    let firstName: String
    let lastName: String
    let emailAdress: String
    let password: String
}

class AuthService {
    
    func checkValidateInfo(_ user: (firstName: String, lastName: String),
                           _ email: String,
                           password: String,
                           completeion: @escaping (AuthUser?) -> Void ) {
        
        guard (isPasswordValid(password) && isEmailValidate(email)) else {
            completeion(nil)
            return
        }
        
        completeion(AuthUser(firstName: user.firstName, lastName: user.lastName, emailAdress: email, password: password))
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print(error)
            } else {
                let dataBase = Firestore.firestore()
                dataBase.collection("users").addDocument(data: [
                    "lastName": user.lastName,
                    "firstName": user.firstName,
                    "email": email,
                    "UID": result!.user.uid
                ]) { (err) in
                    if let error = err {
                        print(error)
                    }
                }
            }
        }
    }
    
    func isEmailValidate(_ email:String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: email) && !(email == "")

    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password) && (password == "")
    }
    
    func auth() {
    
    }
    
}
