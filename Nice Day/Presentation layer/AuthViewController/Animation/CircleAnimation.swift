//
//  user.swift
//  Nice Day
//
//  Created by Михаил Борисов on 15/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

// MARK: - Cricle Animation
final class CircleAnimation: NSObject {

    private enum State {
        case expanded
        case collapsed

        var change: State {
            switch self {
            case .expanded: return .collapsed
            case .collapsed: return .expanded
            }
        }
    }

    private var widthConstraints: NSLayoutConstraint!
    private var centerYConstraints: NSLayoutConstraint!
    private var initialWidthConstraints: NSLayoutConstraint!
    private var initialCenterYConstraints: NSLayoutConstraint!

    private var animatorIsReady: Bool {
        return animator.fractionComplete == 0
    }

    private var animationProgress: CGFloat = 0

    private lazy var state: State = .collapsed

    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
    }()

    private unowned var delegate: UIViewController

    private unowned var containerView: UIView

    private unowned var button: UIButton

    private unowned var container: ContainerViewConfigurable

    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()

    internal init(container: ContainerViewConfigurable, delegate: UIViewController, button: UIButton) {
        self.delegate = delegate
        self.containerView = container.view
        self.button = button
        self.container = container
        super.init()

        DispatchQueue.main.async { [unowned self] in
            self.performContainer()
            self.configureButton()
        }
    }

    private func configureButton() {
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }

    private func performContainer() {
        delegate.view.addSubview(containerView)

        containerView.addGestureRecognizer(panRecognizer)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggle)))

        let centerYConstraint = containerView.centerYAnchor.constraint(equalTo: delegate.view.centerYAnchor)
        let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: 200)
        let finishedWidthConstraint = containerView.widthAnchor.constraint(equalToConstant: 600)
        let finishedCenterYConstraint = containerView.centerYAnchor.constraint(equalTo: delegate.view.centerYAnchor, constant: delegate.view.bounds.height / 3)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: delegate.view.centerXAnchor),
            centerYConstraint,
            widthConstraint,
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        self.initialCenterYConstraints = centerYConstraint
        self.initialWidthConstraints = widthConstraint
        self.widthConstraints = finishedWidthConstraint
        self.centerYConstraints = finishedCenterYConstraint
    }

    private var popupOffset: CGFloat {
        return (delegate.view.bounds.height - containerView.frame.height) / 2
    }

    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
        case .began:
            toggle()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete

        case .changed:
            let translation = recognizer.translation(in: delegate.view)
            var fraction = -translation.y / popupOffset
            if state == .collapsed || animator.isReversed { fraction *= -1 }

            animator.fractionComplete = fraction + animationProgress

        case .ended:
            let velocity = recognizer.velocity(in: containerView)
            let shouldComplete = -velocity.y > 0
           // os_log("Velocity Y: %{public}@", log: OSLog.animation, type: .info, velocity.y)

            guard velocity.y != 0 else {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }

            switch state {
            case .expanded:
                if !shouldComplete && !animator.isReversed || shouldComplete && animator.isReversed { animator.isReversed.toggle() }
            case .collapsed:
                if shouldComplete && !animator.isReversed || !shouldComplete && animator.isReversed { animator.isReversed.toggle() }
            }

            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }

    @objc private func toggle() {
        guard animatorIsReady else { return }
        switch self.state {
        case .expanded:
            self.collapse()
        case .collapsed:
            self.expand()
        }
    }

    private func toggleWdith() {
        (initialWidthConstraints.constant, widthConstraints.constant) = (widthConstraints.constant, initialWidthConstraints.constant)
    }

    private func toggleCenterY() {
        (centerYConstraints.constant, initialCenterYConstraints.constant) = (initialCenterYConstraints.constant, centerYConstraints.constant)
    }

    private func expand() {
        animator.addAnimations { [weak self] in
            self?.container.toggleContainer(state: 1)
            self?.toggleWdith()
            self?.delegate.view.layoutIfNeeded()
        }

        animator.addAnimations({ [weak self] in
            self?.toggleCenterY()
            self?.delegate.view.layoutIfNeeded()
        }, delayFactor: 0.3)

        animator.addCompletion { [weak self] position in
            self?.completionAction(position)
        }
        animator.startAnimation()
    }

    private func collapse() {
        animator.addAnimations { [weak self] in
            self?.container.toggleContainer(state: 0)
            self?.toggleWdith()
            self?.toggleCenterY()
            self?.delegate.view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] position in
            self?.completionAction(position)
        }

        animator.startAnimation()
    }

    private func completionAction(_ position: UIViewAnimatingPosition) {

        container.disableKeyboard()
        switch position {
        case .end:
            self.state = self.state.change
        case .start:
            self.toggleWdith()
            self.toggleCenterY()
        case _:
            ()
        }
    }
}
