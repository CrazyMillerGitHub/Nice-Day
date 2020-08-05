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

    func forgotPasswordAction()
    func signAction()

}

protocol HUDViewProtocol: class {

    func toggleHud(status: Bool)
    
}

final class ContainerView: UIView {

     override func layoutSubviews() {
        super.layoutSubviews()
           layer.cornerRadius = bounds.size.width/2
       }
}

final class ContainerViewController: UIViewController, ContainerViewConfigurable {

    // MARK: - Property init
    private(set) var authType: AuthViewController.AuthViewType

    // lazy var userNameAndPassword
    private(set) lazy var userTextField = UITextField.container(.user)
    // inizialization textField
    private(set) lazy var emailTextField = UITextField.container(.email)

    // inizialization textField
    private(set) lazy var passwordTextField = UITextField.container(.password)

    // lazy inizialization of stackView
    private(set) lazy var mainStackView = UIStackView.container

    // lazy return label instanse with gesture when user forgot password
    private(set) lazy var forgotPasswordLabel = UILabel.forgotPassword.with { label in
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordAction)))
        label.alpha = 0
    }

    // lazy return sign in/up button
    private(set) lazy var signButton: UIButton = UIButton.signIn.with { button in
        button.addTarget(self, action: #selector(signAction), for: .touchUpInside)
        button.alpha = 0
    }

    private var textFieldConfiguration: ContainerPresenter!

    init(authType: AuthViewController.AuthViewType) {
        self.authType = authType
        super.init(nibName: nil, bundle:  nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = ContainerView()
        // set title for sign button
        signButton.setTitle(authType.value, for: .normal)
        // set color to sunrize
        view.backgroundColor = .sunriseColor
        // add userTextField
        if authType == .signUp {
            mainStackView.addArrangedSubview(userTextField)
        }
        configureMainStack()
        // add forgot password label
        view.addSubview(forgotPasswordLabel)
        // add stackView
        view.addSubview(mainStackView)
        print(mainStackView.alpha)
        // add button
        view.addSubview(signButton)
    }

    private func configureMainStack() {
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldConfiguration = ContainerPresenter(delegate: self)
    }
}

// TODO: Вынести в отдельный регистр
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
//        delegate?.toggleHud(status: true)
        authType == .signUp ? signUpAction() : signInAction()
    }

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
                                        if let user = authUser {
                                            self.saveToCoreData(data: (firstName: user.firstName, lastName: user.lastName))
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
                if let user = authUser {
                    self.saveToCoreData(data: (firstName: user.firstName, lastName: user.lastName))
                    self.presentView()
                }
            }
        }
    }

    @nonobjc func saveToCoreData(data: (firstName: String, lastName: String)) {
        let backgroundContext = CoreDataManager.shared.context(on: .private)
        backgroundContext.perform {
            CoreDataManager.shared.createOrUpdateUser(context: backgroundContext, info: data)
        }
    }
    
    /// present view
    func presentView() {
        // init instance of mainView
        let mainView = MainView()
        // set modal style to full screen
        mainView.modalPresentationStyle = .fullScreen
        // toggle HUD
//        self.delegate?.toggleHud(status: false)
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
//        self.delegate?.toggleHud(status: false)
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
