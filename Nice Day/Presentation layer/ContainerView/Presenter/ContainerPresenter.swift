//
//  TextFieldDelegate.swift
//  Nice Day
//
//  Created by Михаил Борисов on 31.03.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//
//

import UIKit
import CocoaTextField

protocol ContainerViewConfigurable where Self: UIViewController {

    var authType: AuthViewController.AuthViewType { get }
    var userTextField: CocoaTextField { get }
    var emailTextField: CocoaTextField { get }
    var mainStackView: UIStackView { get }
    var signButton: UIButton {get}
    var passwordTextField: CocoaTextField { get }

    func toggleContainer(state: Int)
}

extension ContainerViewConfigurable {

    func toggleContainer(state: Int) {
        self.mainStackView.alpha = state == 0 ? 0 : 1
        self.signButton.alpha = state == 0 ? 0 : 1
    }
}

final class ContainerPresenter: NSObject, UITextFieldDelegate {

    private unowned var delegate: ContainerViewConfigurable

    init(delegate: ContainerViewConfigurable) {
        self.delegate = delegate
        super.init()
        prepareConstraints()
        configureTextFields()
    }

    private func configureTextFields() {
        
        delegate.emailTextField.delegate = self
        delegate.passwordTextField.delegate = self
        if delegate.authType == .signUp {
            delegate.userTextField.delegate = self
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case delegate.userTextField:
            delegate.emailTextField.becomeFirstResponder()
        case delegate.emailTextField:
            delegate.passwordTextField.becomeFirstResponder()
        case _:
            textField.resignFirstResponder()
        }

        return false
    }

    private func prepareConstraints() {
        NSLayoutConstraint.activate([
            delegate.signButton.heightAnchor.constraint(equalToConstant: 56),
            delegate.signButton.centerXAnchor.constraint(equalTo: delegate.view.centerXAnchor),
            delegate.signButton.centerYAnchor.constraint(equalTo: delegate.view.centerYAnchor, constant: 50),
            delegate.signButton.widthAnchor.constraint(equalTo: delegate.view.widthAnchor, multiplier: 0.5),

            delegate.mainStackView.widthAnchor.constraint(equalTo: delegate.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            delegate.mainStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            delegate.mainStackView.centerXAnchor.constraint(equalTo: delegate.view.safeAreaLayoutGuide.centerXAnchor),

            delegate.mainStackView.bottomAnchor.constraint(equalTo: delegate.signButton.topAnchor, constant: -80)

        ])
    }
}
