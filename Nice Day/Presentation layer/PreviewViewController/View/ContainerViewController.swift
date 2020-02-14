//
//  ContainerViewController.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import AnimationFramework

@objc protocol ContainerViewProtocol {

    // forgot action
    func forgotPasswordAction()

    // signIn action
    func signInAction()

}

class ContainerViewController: UIViewController {

    // inizialization textField
    lazy var emailTextField = UITextField.container(.email)

    // inizialization textField
    lazy var passwordTextField = UITextField.container(.password)

    // inizialization property animation
    private var animation = UIViewPropertyAnimator(duration: 1, curve: .easeOut)

    // lazy inizialization of stackView
    lazy var stackView = UIStackView.container

    // lazy return label instanse with gesture when user forgot password
    lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel.forgotPassword
        label.alpha = 0
        // add tapGesture to label
        label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(forgotPasswordAction)))
        return label
    }()

    // lazy return logIn button
    lazy var signInButton: UIButton = {
        // inizialization Button
        let button = UIButton.signIn
        button.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        return button
    }()
    
    // loadView()
    override func loadView() {
        super.loadView()
        // set color to sunrize
        view.backgroundColor = .sunriseColor
        // add emailTextField
        stackView.addArrangedSubview(emailTextField)
        // add passwordtextField
        stackView.addArrangedSubview(passwordTextField)
        // add forgot password label
        view.addSubview(forgotPasswordLabel)
        // add stackView
        view.addSubview(stackView)
        // add button
        view.addSubview(signInButton)
        // prepare constraint
        prepareConstraints()
        
        AnimationService.delegate = self
    }

}

// MARK: Prepare Constraints extension
private extension ContainerViewController {

    func prepareConstraints() {
        NSLayoutConstraint.activate([
            
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.07),
            // forgot password constraints
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            forgotPasswordLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            // signInButton Constraint
            signInButton.heightAnchor.constraint(equalToConstant: 56),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }

}

extension ContainerViewController: AnimationProtocol {
    
    func contentNeedToChange(state: Bool) {
        switch state {
        case true:
            // make empty textField
            for textField in [emailTextField, passwordTextField] {
                textField.text = ""
            }
            
            UIView.animate(withDuration: 0.4) {
                
                [self.stackView,
                 self.forgotPasswordLabel,
                 self.signInButton].forEach { $0.alpha = 0 }
            }
        case false:
            UIView.animate(withDuration: 0.4) {
                
                [self.stackView,
                self.forgotPasswordLabel,
                self.signInButton].forEach { $0.alpha = 1 }
            }
        }
    }
    
}

// MARK: action extension
@objc extension ContainerViewController: ContainerViewProtocol {

    // forgot password Action
    func forgotPasswordAction() {
        #if DEBUG
        print(#function)
        #endif
    }

    // sign in action
    func signInAction() {
        #if DEBUG
        #endif

        AuthManager.shared.checkValidateInfo((firstName: "Mike", lastName: "Borisov"), emailTextField.text!.lowercased(), password: passwordTextField.text!) { (user) in
            print(user)
        }
        /*
         AuthService.login { (error, result) in
         ...
         }
         */
    }

}
