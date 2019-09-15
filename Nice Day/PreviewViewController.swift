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
    let animationView: AnimationView = {
        let animationView = AnimationView()
        let animation = Animation.named("file")
        animationView.animation = animation
        animationView.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        return animationView
    }()
    let appleSignInButton : ASAuthorizationAppleIDButton = {
        let appleSignInButton = ASAuthorizationAppleIDButton()
        appleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        return appleSignInButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NSLayoutConstraint.activate([
                     appleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                     appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                     appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)])
        // Do any additional setup after loading the view.
    }
    
    // настройка PreviewViewController
    private func setupView() {
        view.addSubview(animationView)
        view.addSubview(label)
        view.addSubview(appleSignInButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView.play(fromProgress: 0.2, toProgress: 1.0, loopMode: nil, completion: nil)
        //Animation
    }
}
