//
//  AuthViewPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 29.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import JGProgressHUD
import AnimationFramework

@objc protocol AuthViewCallable where Self: UIViewController {
    var emailButton: UIButton { get }
}

final class AuthViewPresenter: NSObject {

    private let container: ContainerViewConfigurable
    private weak var delegate: AuthViewCallable?
    private var circleAnimator: CircleAnimation!

    init(delegate: AuthViewCallable, container: ContainerViewController) {
        self.delegate = delegate
        self.container = container
        super.init()
        DispatchQueue.main.async { [unowned self] in
            self.circleAnimator = CircleAnimation(container: container.view, deleagate: delegate, button: delegate.emailButton, cont: container)
            self.presentConstraints()
        }

    }

    private func presentConstraints() {
        
    }

}
