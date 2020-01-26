//
//  SignUP.swift
//  Nice Day
//
//  Created by Михаил Борисов on 09.01.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

class SignUpView: UIViewController {
    
    @IBOutlet private var emailTextField: UITextField!
    
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var userNameTextfield: UITextField!

    var authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ddddd")
    }
    
    private func isTextFieldsIsNotEmpty(completion: @escaping ([String:String]?) -> Void ) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            completion(nil)
            return
        }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  else {
            completion(nil)
            return
            
        }
        guard let userInfo = userNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)  else {
            completion(nil)
            return
        }
        
        completion(["email": email, "password": password , "userInfo": userInfo])
    }
    
    func presentSignUpRequest(completionHandler: @escaping ([String]?) -> Void) {
        isTextFieldsIsNotEmpty { [weak self] (data) in
            guard let self = self else {
                return
            }
            guard let data = data else {
                completionHandler(["Error"])
                return
            }
            guard let email = data["email"],
                let password = data["password"],
                let userInfo = data["userInfo"]?.split(separator: " ").map(String.init) else {
                    completionHandler(["Error"])
                    return
            }
            
            guard let firstName = userInfo.first else { return }
            let lastName = userInfo.count > 1 ? userInfo[1] : "user"
            
            self.authService.checkValidateInfo((firstName: firstName, lastName: lastName), email, password: password) { [weak self] (response) in
                completionHandler(["Success"])
            }
        }
    }
    
}
