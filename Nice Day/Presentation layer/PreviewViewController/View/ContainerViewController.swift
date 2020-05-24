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
    func signAction()

}

protocol HUDViewProtocol: class {
    
    // toggleHUD
    func toggleHud(status: Bool)
    
}

class ContainerViewController: UIViewController, UITextFieldDelegate {

    private var authType: AuthViewType!
    
    init(authType: AuthViewType) {
        self.authType = authType
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // lazy var userNameAndPassword
    lazy private var userTextField = UITextField.container(.user)
    // inizialization textField
    lazy private var emailTextField = UITextField.container(.email)

    // inizialization textField
    lazy private var passwordTextField = UITextField.container(.password)

    // inizialization property animation
    private var animation = UIViewPropertyAnimator(duration: 1, curve: .easeOut)

    // lazy inizialization of stackView
    lazy private var stackView = UIStackView.container

    // lazy return label instanse with gesture when user forgot password
    lazy private var forgotPasswordLabel: UILabel = {
        let label = UILabel.forgotPassword
        label.alpha = 0
        // add tapGesture to label
        label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(forgotPasswordAction)))
        return label
    }()

    // lazy return sign in/up button
    lazy private var signButton: UIButton = {
        // inizialization Button
        let button = UIButton.signIn
        button.addTarget(self, action: #selector(signAction), for: .touchUpInside)
        return button
    }()
    
    // setting up delegate
    weak var delegate: HUDViewProtocol?
    
    // loadView()
    override func loadView() {
        super.loadView()
        // set title for sign button
        signButton.setTitle(authType.rawValue.localized, for: .normal)
        // set color to sunrize
        view.backgroundColor = .sunriseColor
        // add userTextField
        if authType == .signUp {
            stackView.addArrangedSubview(userTextField)
        }
        // add emailTextField
        stackView.addArrangedSubview(emailTextField)
        // add passwordtextField
        stackView.addArrangedSubview(passwordTextField)
        // add forgot password label
        view.addSubview(forgotPasswordLabel)
        // add stackView
        view.addSubview(stackView)
        // add button
        view.addSubview(signButton)
        // prepare constraint
        prepareConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // add textfields' delegate
        if authType == .signUp {
            userTextField.delegate = self
        }
        // add delegate to emailTextField
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // add animation service delegate
        AnimationService.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case userTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case _:
            textField.resignFirstResponder()
        }
        
        return false
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
            signButton.heightAnchor.constraint(equalToConstant: 56),
            signButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            signButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
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
                 self.signButton].forEach { $0.alpha = 0 }
            }
        case false:
            UIView.animate(withDuration: 0.4) {
                
                [self.stackView,
                self.forgotPasswordLabel,
                self.signButton].forEach { $0.alpha = 1 }
            }
        }
    }
    
}

// MARK: action extension
@objc extension ContainerViewController: ContainerViewProtocol {

    /// action which will be when user forgot password
    func forgotPasswordAction() {
        let supportView = SupportView()
        supportView.modalPresentationStyle = .fullScreen
        self.present(supportView, animated: true, completion: nil)
    }

    // sign action
    func signAction() {
        delegate?.toggleHud(status: true)
        authType == .signUp ? signUpAction() : signInAction()
    }
    
    /// <#Description#>
    private func signUpAction() {
        
        let userInfo = userTextField.text!.capitalized.split(separator: " ").map(String.init)
        
        AuthManager.shared.signUp((firstName: userInfo.first ?? "", lastName: userInfo.last ?? ""),
                                  emailTextField.text!.lowercased(),
                                  password: passwordTextField.text!) { [weak self] (err, authUser) in
                                    guard let self = self else { return }
                                    // working with error
                                    if let err = err {
                                        self.errorHandler(err: err)
                                    } else {
                                        // working with user output
                                        if authUser != nil {
                                            self.presentView()
                                        }
                                    }
        }
        
    }

    private func signInAction() {
        
        AuthManager.shared.signIn(emailTextField.text!.lowercased(), passwordTextField.text!) { [weak self] err, authUser in
            
            guard let self = self else { return }
            
            if let err = err {
                self.errorHandler(err: err)
            } else {
                if authUser != nil {
                    self.presentView()
                }
            }
        }
    }
    
    /// present view
    func presentView() {
        // init instance of mainView
        let mainView = MainView()
        // set modal style to full screen
        mainView.modalPresentationStyle = .fullScreen
        // toggle HUD
        self.delegate?.toggleHud(status: false)
        // present view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // present MainView
            self.present(mainView, animated: true, completion: nil)
        }
    }
    
    /// error handler action
    /// - Parameter err: error string that need to be displayed
    func errorHandler(err: String) {
        // disable HUD
        self.delegate?.toggleHud(status: false)
        // init view with parametres
        let alertView = AlertService().alert(title: "Something went wrong!",
                                             body: err,
                                             button: "Ok")
        // present alierView for user
        // set style to over full screen
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        // present View
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // present AlertView
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
}
