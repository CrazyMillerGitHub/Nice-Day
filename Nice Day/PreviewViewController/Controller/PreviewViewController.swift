//
//  PreviewViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 03/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Lottie
import AuthenticationServices
class PreviewViewController: UIViewController {
    let label: UILabel = {
        let label = HelloLabel()
        return label
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
        NSLayoutConstraint.activate([
                     appleSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
                     appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                     appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
                     appleSignInButton.heightAnchor.constraint(equalToConstant: CGFloat(46.0))])
    }
    
    // настройка PreviewViewController
    private func setupView() {
        view.addSubview(label)
        view.addSubview(appleSignInButton)
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
}
extension PreviewViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Authorization completed!")
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = UserStruct(credentials: credentials)
            print(user)
        default: break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed with error: \(error)")
    }
}

extension PreviewViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
