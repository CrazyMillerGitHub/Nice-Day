//
//  AnimationFramework.swift
//  AnimationFramework
//
//  Created by Михаил Борисов on 10.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

public protocol AnimationProtocol: class {

    /// content need to hide/unhide
    /// - Parameter state: state of container: hide/unhide
    func contentNeedToChange(state: Bool)
}

public class AnimationService {

    // set isHidden container in authViewController
    private static var isHidden: Bool = false {
        didSet {
            // detect if old and new value are different
            if oldValue != isHidden {
                animateElements(isHidden)
            }
        }

    }

    // set progressValue to combine animations
    private(set) static var progressValue: CGFloat = 0.0 {
        didSet {
            // set isHidden value
            isHidden = progressValue > 0.5 ? true : false
        }
    }

    public weak static var delegate: AnimationProtocol?

    public static func callBackAnimation(_ object: UIView,
                                         in view: UIView,
                                         action: @escaping () -> Void) {
        // Start of animation
        UIView.animate(withDuration: 1, animations: {
            // change label position to center; alpha to 1 (want to see our label)
            object.center = view.center
            object.alpha = 1
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                    // dismiss animatio to beginning state
                    object.center = CGPoint(x: view.center.x, y: view.center.y + 120)
                    object.alpha = 0
                }, completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        // prepare to comform transition to be done
                        action()
                    }
                })
            }
        })
    }


    @objc public static func circleTapAnimation(in view: UIView,
                                                widthConstraint: NSLayoutConstraint,
                                                centerYConstraint: NSLayoutConstraint,
                                                action: @escaping () -> Void ) {
        // create property wuth ease in out animation, duration: 1
        UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            // create started keyframe with duration 1
            UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    // change constant to x3
                    widthConstraint.constant *= 3
                    view.layoutIfNeeded()

                })

                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 1, animations: {
                    centerYConstraint.constant += UIScreen.main.bounds.height / 3
                    // force update subView method
                    view.layoutIfNeeded()
                })

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
                    delegate?.contentNeedToChange(state: false)
                })
            })
        }.startAnimation()

        // perform escaping function
        action()

    }

    // swiftlint:disable function_parameter_count
    public static func slideDownAnimation(to view: UIView,
                                          animator: inout UIViewPropertyAnimator,
                                          widthConstraint: NSLayoutConstraint,
                                          centerYConstraint: NSLayoutConstraint,
                                          panGesture: UIPanGestureRecognizer,
                                          tapGesture: UITapGestureRecognizer,
                                          sender: UIPanGestureRecognizer) {
        // swiftlint:enable function_parameter_count

        // detect state of sender
        switch sender.state {
        // sender state changed to began
        case .began:
            // end editing
            view.endEditing(true)
            // check if animator is not running
            guard !animator.isRunning else {
                break
            }
            // inizialize animator
            animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
                centerYConstraint.constant -= UIScreen.main.bounds.height / 3
                widthConstraint.constant /= 3
                view.layoutIfNeeded()
            }

        case .changed:
            // detect transition
            let translation = sender.translation(in: view).y
            // change fraction complete state (from 0.0 to 1.0)
            progressValue = min(max(0.01, (translation / -400)), 0.96)
            if progressValue < 0.96 {
                animator.fractionComplete = progressValue
            }
        // sender state changed to ended (when animation completed)
        case .ended:
            // disable pan gesture
            panGesture.isEnabled = false
            // switch which state have our animation
            switch animator.fractionComplete {
            // animator.fractionComplete between 0 and 0.5
            case 0...0.5:
                // change direction of animation
                animator.isReversed.toggle()
                // continue animation
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.3)
                animator.addCompletion { _ in
                    // change constant asynchronasly in main Thread
                    DispatchQueue.main.async {
                        widthConstraint.constant *= 3
                        centerYConstraint.constant += UIScreen.main.bounds.height / 3
                    }
                }
                // switch state of Pan Gesture
                panGesture.isEnabled.toggle()
            case _:
                // continue animation
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.3)
                // set state of tapGesture to normal state
                tapGesture.isEnabled.toggle()
            }
        case _:
            // other states not supported right now
            break
        }
    }

    // animate elements inside container
    private static func animateElements(_ state: Bool) {
        switch state {
        case true:
            printConsole("Prepared to animate hide")
            delegate?.contentNeedToChange(state: true)
        case false:
            printConsole("Prepared to animate unhide")
            delegate?.contentNeedToChange(state: false)
        }
    }

}

// MARK: debug print
private extension AnimationService {

    /// print inside console if mode set to debug
    /// - Parameter message: message inside Console
    static func printConsole<T: Any>(_ message: T) {
        #if DEBUG
        print(message)
        #endif
    }
}
