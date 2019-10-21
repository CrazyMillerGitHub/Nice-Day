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
import PMSuperButton
class AuthViewController: UIViewController {
    
    let friendlyLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello! I’m\nyour friend,\nMike"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    weak var topConstraint: NSLayoutConstraint!
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        return view
    }()
    
    let circleView: UIView = {
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
    
    let emailButton: PMSuperButton = {
        let button = PMSuperButton()
        button.backgroundColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
        button.setTitle("Sign in with email and password", for: .normal)
        button.tintColor = UIColor.white
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.animatedScaleWhenHighlighted = 0.9
        button.animatedScaleDurationWhenHighlighted = 0.3
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(emailDidTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    let ttleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nice Day"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    
    let dscrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Be better every day!"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.isHidden = true
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let appleSignInButton : ASAuthorizationAppleIDButton = {
        let appleSignInButton = ASAuthorizationAppleIDButton()
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButton.addTarget(self, action: #selector(didTapAppleIDButton(sender:)), for: .touchUpInside)
        return appleSignInButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.view.backgroundColor = .bgColor
       containerView.backgroundColor = .clear
       let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "container")
       addChild(controller)
    
       let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
       swipeUp.direction = .down
       self.containerView.addGestureRecognizer(swipeUp)
        
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
    
    @objc
    private func handleGesture(gesture: UISwipeGestureRecognizer) {
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
    
    @objc private func didTapAppleIDButton(sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
      private func prepareUI() {
          self.view.addSubview(ttleLabel)
          self.view.addSubview(dscrLabel)
          self.view.addSubview(circleView)
          self.view.addSubview(emailButton)
          self.view.addSubview(signInButton)
          view.addSubview(containerView)
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
      @objc private func emailDidTapped(sender: Any) {
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
         
      }
}
extension AuthViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Authorization completed!")
        switch authorization.credential {
        case _ as ASAuthorizationAppleIDCredential:
//            let user = UserStruct(credentials: credentials)
            guard let mainController = storyboard?.instantiateViewController(identifier: "mainController") else { assert(false, "Not found!") }
            mainController.modalPresentationStyle = .fullScreen
            self.present(mainController, animated: true, completion: nil)
        default: break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed with error: \(error)")
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
