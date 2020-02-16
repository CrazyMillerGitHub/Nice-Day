//
//  SplashViewController+delegate.swift
//  Stack_test
//
//  Created by Михаил Борисов on 10.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

class SplashViewControllerTransition: NSObject, UIViewControllerTransitioningDelegate {

    // set transition
    let transition = FadeAnimator()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
