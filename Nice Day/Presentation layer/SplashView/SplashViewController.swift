//
//  SplashViewController.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import AnimationFramework

class SplashViewController: UIViewController {

    lazy var splashLabel = UILabel.splash

    var transition: SplashViewControllerTransition

    // dependency injection
    init(_ transition: SplashViewControllerTransition) {
        self.transition = transition
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        splashLabel.center = CGPoint(x: view.center.x, y: view.center.y + 120)
        view.addSubview(splashLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AnimationService.callBackAnimation(splashLabel, in: self.view) { [weak self] in
            self?.performAnimationToMainView()
        }
    }

}

private extension SplashViewController {

    func performAnimationToMainView() {
        let view = UserDefaults.standard.object(forKey: "loggedIn") == nil || UserDefaults.standard.object(forKey: "loggedIn") as? Bool == false ? OnboardingView() : MainView()
        view.modalPresentationStyle = .custom
        view.transitioningDelegate = transition
        self.present(view, animated: true, completion: nil)
    }

}
