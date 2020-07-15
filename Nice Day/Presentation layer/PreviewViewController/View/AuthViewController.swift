//
//  MainViewController.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import CryptoKit
import JGProgressHUD
import Firebase
import FirebaseFirestore
import AnimationFramework
import AuthenticationServices

enum AuthViewType: String {
    case signIn = "_sign_in"
    case signUp = "_sign_up"
}

class AuthViewController: UIViewController {

    //private var appleSignInDelegates: SignInWithAppleDelegates! = nil

    private var currentNonce: String?

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
    // return button init
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("_go_back".localized, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
        button.setTitleColor(UIColor.inverseColor.withAlphaComponent(0.7), for: .normal)
        return button
    }()
    // inizialize apple button
    private var appleSignButton: ASAuthorizationAppleIDButton!
    // inizialize HUD
    var hud: JGProgressHUD!
    // return Container view
    private var containerView: ContainerViewController!

    // loadView()
    override func loadView() {
        super.loadView()
        // perform appleSign
        appleSignButton = UIButton.appleSignIn(authViewType == .signUp ? .signIn : .`continue`,
                                                      traitCollection.userInterfaceStyle == .light ? .black : .white)
        // TODO: AppleSignIn
        appleSignButton.isHidden = true
        // perform JGProgress
        performJGProgress()
        // add target to button
        appleSignButton.addTarget(self, action: #selector(appleSignAction), for: .touchUpInside)
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

    var counter = 0

}

// Prepare UI and Constraints
private extension AuthViewController {

    func performJGProgress() {
        let hud = JGProgressHUD(style: traitCollection.userInterfaceStyle == .light ? .light : .dark)
        hud.textLabel.text = "Loading"
        self.hud = hud
    }
 
    /// prepare ui by adding elements to superView
    func prepareUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(emailButton)
        view.addSubview(appleSignButton)
        view.addSubview(returnButton)
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
            
            appleSignButton.topAnchor.constraint(equalTo: containerView.view.bottomAnchor, constant: 60),
            appleSignButton.heightAnchor.constraint(equalToConstant: 46.0),
            appleSignButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appleSignButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2 + 120),
            
            emailButton.topAnchor.constraint(equalTo: self.appleSignButton.bottomAnchor, constant: 20),
            emailButton.leadingAnchor.constraint(equalTo: self.appleSignButton.leadingAnchor, constant: 0),
            emailButton.trailingAnchor.constraint(equalTo: self.appleSignButton.trailingAnchor, constant: 0),
            emailButton.heightAnchor.constraint(equalToConstant: CGFloat(46.0)),

            // return back Button
            returnButton.heightAnchor.constraint(equalTo: emailButton.heightAnchor, multiplier: 0.7),
            returnButton.widthAnchor.constraint(equalTo: emailButton.widthAnchor),
            returnButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 20),
            returnButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        // add dependecies to properties
        self.widthConstraint = widthConstraint
        self.centerYConstraint = centerYConstraint
    }

    @objc private func returnButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
    
    func appleSignAction() {
       showAppleLogin()
    }

}

extension AuthViewController: HUDViewProtocol {
    
    func toggleHud(status: Bool) {
        // check status of HUD
        switch status {
        case true:
            // show hud
            hud.show(in: self.view)
        case false:
            // dismiss hud
            hud.dismiss(animated: true)
        }
    }
}

extension AuthViewController {

    private func showAppleLogin() {
        counter += 1
        if counter == 2 {
            let view = TestViewController()
            self.present(view, animated: true, completion: nil)
        } else {
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)

            performSignIn(using: [request])
        }

    }

    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        guard let currentNonce = self.currentNonce else {
            return
        }
        //appleSignInDelegates = SignInWithAppleDelegates(window: nil, currentNonce: currentNonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = appleSignInDelegates
//        authorizationController.presentationContextProvider = appleSignInDelegates
        authorizationController.performRequests()
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if length == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
