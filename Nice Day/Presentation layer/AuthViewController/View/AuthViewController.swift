//
//  MainViewController.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import JGProgressHUD

final class AuthViewController: UIViewController, AuthViewCallable {

    // MARK: - Property init
    internal enum AuthViewType {

        case signIn, signUp

        var value: String {
            switch self {
            case .signIn:
                return "_sign_in".localized
            case .signUp:
                return "_sign_up".localized
            }
        }
    }

    private var titleLabel = UILabel.title
    private var descriptionLabel = UILabel.description
    private var presenter: AuthViewPresenter!
    private let authBehavior: AuthViewType

    internal lazy var emailButton = UIButton.emailSignIn

    private lazy var dismissButton = UIButton().with { button in
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("_go_back".localized, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        button.setTitleColor(UIColor.inverseColor.withAlphaComponent(0.7), for: .normal)
    }

    // return Container view
    private lazy var containerView = ContainerViewController(authType: authBehavior).with { containerView in
        containerView.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.view.isUserInteractionEnabled = true
    }

    internal init(authBehavior: AuthViewType) {
        self.authBehavior = authBehavior
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboadBehavior(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboadBehavior(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // loadView()
    override func loadView() {
        super.loadView()

        DispatchQueue.main.async { [unowned self] in
            self.presenter = AuthViewPresenter(delegate: self, container: self.containerView)
        }
        view.backgroundColor = .bgColor
        prepareUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(containerView)
        prepareConstraints()

        // set delegate
//        self.containerView.delegate = self
    }

    @objc private func keyboadBehavior(_ notification: NSNotification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            guard view.frame.origin.y == 0, let userInfo = notification.userInfo,
                let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { break }
            view.frame.origin.y -= keyboardSize.cgRectValue.height / 2
        case _:
            view.frame.origin.y = 0
        }
    }

}

// Prepare UI and Constraints
private extension AuthViewController {

//    func performJGProgress() {
//        let hud = JGProgressHUD(style: traitCollection.userInterfaceStyle == .light ? .light : .dark)
//        hud.textLabel.text = "Loading"
//        self.hud = hud
//    }
 
    /// prepare ui by adding elements to superView
    private func prepareUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailButton)
        view.addSubview(dismissButton)
    }
    
    private func prepareConstraints() {

        NSLayoutConstraint.activate([
            // adding top padding to constant 79
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 79),
            // set leading anchor to 33 [leading - view - trailing]
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 33),
            // set title height to 43
            titleLabel.heightAnchor.constraint(equalToConstant: 43),
            // set trailing anchor to -33 [leading - view - trailing]
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -33),
            // set describtion label equal to title label leading
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            // set trailing label equal to title label trailing
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            // set top anchor to constant 40
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 40),
            // set height anchor equal to titleLabel anchor
            descriptionLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            emailButton.topAnchor.constraint(equalTo: containerView.view.bottomAnchor, constant: 100),
            emailButton.heightAnchor.constraint(equalToConstant: 46.0),
            emailButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 + 120),
            // return back Button
            dismissButton.heightAnchor.constraint(equalTo: emailButton.heightAnchor, multiplier: 0.7),
            dismissButton.widthAnchor.constraint(equalTo: emailButton.widthAnchor),
            dismissButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 20),
            dismissButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    @objc private func returnButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

//extension AuthViewController: HUDViewProtocol {
//
//    func toggleHud(status: Bool) {
//        // check status of HUD
//        switch status {
//        case true:
//            // show hud
//            hud.show(in: self.view)
//        case false:
//            // dismiss hud
//            hud.dismiss(animated: true)
//        }
//    }
//}
