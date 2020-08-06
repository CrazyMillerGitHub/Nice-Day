//
//  FadeAnimator.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

final class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum Constant {
        case duration
        case visible
        case nonVisible
        case delay

        var value: Double {
            switch self {
            case .duration, .visible:
                return 1
            case .nonVisible, .delay:
                return 0
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constant.duration.value
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        containerView.addSubview(toView)
        toView.alpha = CGFloat(Constant.nonVisible.value)
        UIView.animate(withDuration: Constant.duration.value, delay: Constant.delay.value, options: [.curveEaseOut], animations: {
            toView.alpha = CGFloat(Constant.visible.value)
            
        }, completion: { _ in
            transitionContext.completeTransition(true)
            
        })
    }
    
}
