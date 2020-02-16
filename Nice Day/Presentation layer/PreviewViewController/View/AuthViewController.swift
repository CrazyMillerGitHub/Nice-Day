//
//  MainViewController.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import JGProgressHUD
import AnimationFramework
import AuthenticationServices

enum AuthViewType: String {
    case signIn = "_sign_in"
    case signUp = "_sign_up"
}

class AuthViewController: UIViewController {

    // inizialize property panGesture recognizer
    private weak var panGestureRecognizer: UIPanGestureRecognizer!
    // inizialize property tapGesture recognizer
    private weak var tapGestureRecognizer: UITapGestureRecognizer!
    // inizialize property widthConstraint
    private weak var widthConstraint: NSLayoutConstraint!
    // inizialize property centerYConstraint
    private weak var centerYConstraint: NSLayoutConstraint!
    // create animation
    private var animation = UIViewPropertyAnimator(duration: 1, curve: .easeOut)
    // inizialize title Label
    private var titleLabel = UILabel.title
    // inizialize description label
    private var descriptionLabel = UILabel.description
    // set authType
    lazy var authViewType: AuthViewType = .signIn
    // return email button
    private var emailButton: UIButton = {
        let button = UIButton.emailSignIn
        button.addTarget(self, action: #selector(tappedAction), for: .touchUpInside)
        return button
    }()
    // inizialize apple button
    private var appleSignInButton: ASAuthorizationAppleIDButton!
    // inizialize HUD
    var hud: JGProgressHUD {
        let hud = JGProgressHUD(style: traitCollection.userInterfaceStyle == .light ? .light : .dark)
        hud.textLabel.text = "Loading"
        return hud
    }
    // return Container view
    private var containerView: ContainerViewController!
    
    // loadView()
    override func loadView() {
        super.loadView()
        // perform appleSign
        self.appleSignInButton = UIButton.appleSignIn(authViewType == .signUp ? .signIn : .`continue`,
                                                      traitCollection.userInterfaceStyle == .light ? .black : .white)
        // perform containerView
        let containerView = ContainerViewController(authType: authViewType)
        containerView.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.view.isUserInteractionEnabled = true
        // set backgroundColor
        view.backgroundColor = .bgColor
        // create PanGesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(slideDown(_:)))
        // disable gesture right now
        gesture.isEnabled = false
        // add dependency to propery
        self.panGestureRecognizer = gesture
        // create tapGesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedAction))
        // add dependency to property
        self.tapGestureRecognizer = tapGestureRecognizer
        // adding gestures to container view
        containerView.view.addGestureRecognizer(self.panGestureRecognizer)
        containerView.view.addGestureRecognizer(self.tapGestureRecognizer)
        // prepare you
        prepareUI()
        
        self.containerView = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // create containerView and link with superView
        self.add(containerView)
        // set type to containerView
        // adding constraints
        prepareConstraints()
        // add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        // set delegate
        self.containerView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        // set corner radius to a half of container view
        containerView.view.layer.cornerRadius = containerView.view.bounds.width / 2
    }
    
    deinit {
        // deinit observers
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height / 2
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// Prepare UI and Constraints
private extension AuthViewController {

    /// prepare ui by adding elements to superView
    func prepareUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailButton)
        view.addSubview(appleSignInButton)
    }
    
    func prepareConstraints() {
        // inizinalize width constraint
        let widthConstraint = containerView.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        // inizinalize centerYConstraint constraint
        let centerYConstraint = containerView.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        NSLayoutConstraint.activate([
            widthConstraint,
            // add heightAnchor constraint equal to widthConstraint
            containerView.view.heightAnchor.constraint(equalTo: containerView.view.widthAnchor),
            // centre our container in superView
            containerView.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            centerYConstraint,
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
            
            appleSignInButton.topAnchor.constraint(equalTo: containerView.view.bottomAnchor, constant: 60),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 46.0),
            appleSignInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appleSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 + 120),
            
            emailButton.topAnchor.constraint(equalTo: self.appleSignInButton.bottomAnchor, constant: 20),
            emailButton.leadingAnchor.constraint(equalTo: self.appleSignInButton.leadingAnchor, constant: 0),
            emailButton.trailingAnchor.constraint(equalTo: self.appleSignInButton.trailingAnchor, constant: 0),
            emailButton.heightAnchor.constraint(equalToConstant: CGFloat(46.0))
        ])
        // add dependecies to properties
        self.widthConstraint = widthConstraint
        self.centerYConstraint = centerYConstraint
    }

}

// All about animation
@objc private extension AuthViewController {
   
    func slideDown(_ sender: UIPanGestureRecognizer) {
        // inizialize slide down animation
        AnimationService.slideDownAnimation(to: self.view,
                           animator: &animation,
                           widthConstraint: widthConstraint,
                           centerYConstraint: centerYConstraint,
                           panGesture: panGestureRecognizer,
                           tapGesture: tapGestureRecognizer,
                           sender: sender)
    }

    func tappedAction() {
        // inizialize circle tap animation
        AnimationService.circleTapAnimation(in: self.view, widthConstraint: widthConstraint, centerYConstraint: centerYConstraint) {
            // toggle gestures
            self.tapGestureRecognizer.isEnabled.toggle()
            self.panGestureRecognizer.isEnabled.toggle()
        }
    }

}

extension AuthViewController: HUDViewProtocol {
    
    func toggleHud(status: Bool) {
        // check status of HUD
        switch status {
        case true:
            // show hud
            self.hud.show(in: self.view)
        case false:
            // dismiss hud
            self.hud.dismiss()
        }
    }
    
}
