//
//  AuthViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 03/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Lottie
import AuthenticationServices

enum AuthViewType {
    case signIn
    case signUp
}

class AuthViewController: UIViewController {
    
    fileprivate var isActive: Bool = true
    
    fileprivate weak var topConstraint: NSLayoutConstraint!
    
    var appleSignInButton: ASAuthorizationAppleIDButton!
    
    var authViewType: AuthViewType = .signUp
    
    fileprivate var friendlyLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello! I’m\nyour friend,\nMike"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        label.textColor = .inverseColor
        return label
    }()
    
    fileprivate var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
    fileprivate var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
        view.layer.cornerRadius = (UIScreen.main.bounds.width - 160) / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.autoresizesSubviews = false
        view.autoresizingMask = [.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin]
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate var emailButton: ElasticButton = {
        let button = ElasticButton()
        button.backgroundColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
        button.setTitle("_sign_in_with_email_and_password".localized(), for: .normal)
        button.tintColor = UIColor.white
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(emailAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate var ttleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nice Day"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    fileprivate var dscrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Be better every day!"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    fileprivate var signInButton: ElasticButton = {
        let button = ElasticButton()
        button.backgroundColor = .clear
        button.setTitle("_sign_in".localized(), for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.isHidden = true
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        return button
    }()
    
    private func prepareSignInButton() -> ASAuthorizationAppleIDButton {
        let appleSignInButton = ASAuthorizationAppleIDButton(
            type: authViewType == .signIn ? .continue : .default,
            style: self.traitCollection.userInterfaceStyle == .dark ? .white : .black)
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButton.addTarget(self, action: #selector(didTapAppleIDButton(sender:)), for: .touchUpInside)
        return appleSignInButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appleSignInButton = prepareSignInButton()
        setupView()
        self.view.backgroundColor = .bgColor
        containerView.backgroundColor = .clear
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:
            authViewType == .signIn ? "signInContainer" : "signUpContainer")
        addChild(controller)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .down
        self.containerView.addGestureRecognizer(swipeUp)
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(emailAction(sender:)))
        self.circleView.addGestureRecognizer(touchGesture)
        
        prepareUI()
        prepareConstraints()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        controller.didMove(toParent: self)
    }
    
    // настройка PreviewViewController
    private func setupView() {
        view.addSubview(friendlyLabel)
        view.addSubview(appleSignInButton)
    }
    
    // MARK: отмена email auth
    @objc
    private func handleGesture(gesture: UISwipeGestureRecognizer) {
        self.view.endEditing(true)
        self.isActive = true
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
            self.topConstraint.constant -= self.circleView.bounds.height / 1.1
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [], animations: {
                    self.view.layoutIfNeeded()
                    self.circleView.transform = .identity
                }, completion: nil )
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.3) {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
                    self.emailButton.isHidden = false
                    self.emailButton.alpha = 1
                }, completion: nil)
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.4) {
                self.signInButton.isHidden = true
                UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [.curveEaseOut, .transitionCurlUp], animations: {
                    self.signInButton.alpha = 0
                    self.containerView.alpha = 0
                }, completion: nil )
            }
        }, completion: nil)
    }
    
    @objc
    private func didTapAppleIDButton(sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func prepareUI() {
        [ttleLabel,
         dscrLabel,
         circleView,
         emailButton,
         signInButton,
         containerView].forEach(view.addSubview(_:))
    }
    
    private func prepareConstraints() {
        let topConstraint = circleView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([
            
            circleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80.0),
            circleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80.0),
            topConstraint,
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 1.0/1.0),
            
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80.0),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80.0),
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0/1.0),
            
            ttleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 79),
            ttleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 33.0),
            ttleLabel.heightAnchor.constraint(equalToConstant: 43),
            ttleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -33),
            
            dscrLabel.leadingAnchor.constraint(equalTo: ttleLabel.leadingAnchor, constant: 0.0),
            dscrLabel.trailingAnchor.constraint(equalTo: ttleLabel.trailingAnchor, constant: 0),
            dscrLabel.topAnchor.constraint(equalTo: ttleLabel.topAnchor, constant: 40),
            dscrLabel.heightAnchor.constraint(equalTo: ttleLabel.heightAnchor, multiplier: 1.0/1.0),
            
            signInButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signInButton.heightAnchor.constraint(equalToConstant: 46.0),
            signInButton.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 40.0),
            signInButton.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: -40.0),
            
            appleSignInButton.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 60),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 46.0),
            appleSignInButton.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 40.0),
            appleSignInButton.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: -40.0),
            
            emailButton.topAnchor.constraint(equalTo: self.appleSignInButton.bottomAnchor, constant: 20),
            emailButton.leadingAnchor.constraint(equalTo: self.appleSignInButton.leadingAnchor, constant: 0),
            emailButton.trailingAnchor.constraint(equalTo: self.appleSignInButton.trailingAnchor, constant: 0),
            emailButton.heightAnchor.constraint(equalToConstant: CGFloat(46.0))
            
        ])
        self.topConstraint = topConstraint
    }
    
    @objc
    private func emailAction(sender: Any) {
        if self.isActive {
            UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
                self.topConstraint.constant += self.circleView.bounds.height / 1.1
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
                    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [], animations: {
                        self.view.layoutIfNeeded()
                        self.circleView.transform = CGAffineTransform(scaleX: 3, y: 3)
                    }, completion: nil )
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.3) {
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
                        self.emailButton.center.y += 20
                        self.emailButton.alpha = 0
                    }, completion: { _ in self.emailButton.isHidden = true })
                }
                UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.4) {
                    self.signInButton.isHidden = false
                    UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [.curveEaseOut, .transitionCurlUp], animations: {
                        self.signInButton.alpha = 1
                        self.containerView.alpha = 1
                    }, completion: nil )
                }
            }, completion: nil)
            self.isActive = false
        }
    }
    
    @objc
    private func signInAction() {
        DispatchQueue.main.async {
            let mainController = SearchTabBarController()
            mainController.modalPresentationStyle = .fullScreen
            self.present(mainController, animated: true, completion: nil)
        }
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        NSLog("Success!")
        switch authorization.credential {
        case _ as ASAuthorizationAppleIDCredential:
            DispatchQueue.main.async {
                let mainController = SearchTabBarController()
                mainController.modalPresentationStyle = .fullScreen
                self.present(mainController, animated: true, completion: nil)
            }
        default: break
        }
    }
    
    /// Authorization via AppleID falied
    /// - Parameter controller: ASAuthorizationController
    /// - Parameter error: error'
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        NSLog("Authorization failed with error: \(error)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35 ) {
            let mainController = AlertService().alert(title: "Sign in with Apple Failed",
                                                      body: "Something went wrong. Try again later.",
                                                      button: "Ok")
            mainController.modalPresentationStyle = .overFullScreen
            mainController.modalTransitionStyle = .crossDissolve
            self.present(mainController, animated: true, completion: nil)
        }
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
