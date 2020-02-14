//
//  EmailView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 27.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SignInView: UIViewController {
    
    // TODO: View fatal error because view is not inizialized here
    
    @IBOutlet private var forgotButton: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        forgotButton.addTarget(self, action: #selector(forgotAction), for: .touchUpInside)
        forgotButton.setTitle("_forgotPassword".localized(), for: .normal)
        emailTextField.placeholder = "_email".localized()
        passwordTextFiled.placeholder = "_passwd".localized()
    }
    
    func presentSignInRequest(completionHander: @escaping ([String]) -> Void) {
        completionHander(["TestWorked"])
    }
    
    @objc
    private func forgotAction() {
        DispatchQueue.main.async {
            let supportVC = SupportView()
            supportVC.modalPresentationStyle = .fullScreen
            self.present(supportVC, animated: true, completion: nil)
        }
    }
    
}