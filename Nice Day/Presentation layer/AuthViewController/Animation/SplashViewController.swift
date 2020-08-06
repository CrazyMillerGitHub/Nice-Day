//
//  SplashViewController.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import AnimationFramework

final class SplashViewController: UIViewController {

    lazy var splashLabel = UILabel.splash

    weak var transitionDelegate: SplashViewControllerDelegate?

    // dependency injection
    init(_ transitionDelegate: SplashViewControllerDelegate) {
        self.transitionDelegate = transitionDelegate
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
        AnimationService.callBackAnimation(splashLabel, in: self.view) {
            self.performAnimationToMainView()
        }
    }

}

private extension SplashViewController {

    func performAnimationToMainView() {
        let view = AuthViewController()
        view.modalPresentationStyle = .custom
        view.transitioningDelegate = transitionDelegate
        present(view, animated: true, completion: nil)
    }

}
