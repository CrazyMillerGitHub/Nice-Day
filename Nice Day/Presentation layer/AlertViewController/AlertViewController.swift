//
//  AlertViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 30.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    private var animator: UIDynamicAnimator!
    
    private var snapping: UISnapBehavior!
    
    @IBOutlet private var alertView: UIView!
    
    @IBOutlet private var actionButton: UIButton!
    
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var titleLabel: UILabel!
    
    var actionButtonString = String()
    
    var descriptionLabelString = String()
    
    var titleLabelString = String()
    
    override func loadView() {
        super.loadView()
        animator = UIDynamicAnimator(referenceView: view)
        snapping = UISnapBehavior(item: alertView, snapTo: view.center)
        actionButton.addTarget(self, action: #selector(alertAction), for: .touchUpInside)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(alertAction))
        swipeGesture.direction = .down
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedView))
        [swipeGesture, panGesture].forEach(alertView.addGestureRecognizer(_:))
    }
    
    override func viewDidLoad() {
        setupView()
    }

    @objc
    func alertAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func pannedView(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        
        case .began:
            animator.removeBehavior(snapping)
            
        case .changed:
            let translation = recognizer.translation(in: view)
            alertView.center = CGPoint(x: alertView.center.x + translation.x,
                                       y: alertView.center.y + translation.y)
            recognizer.setTranslation(.zero, in: view)
        
        case .ended, .cancelled, .failed:
            animator.addBehavior(snapping)
            
        case _:
            break
            
        }
    }
}
private extension AlertViewController {
    
    func setupView() {
        actionButton.setTitle(actionButtonString, for: .normal)
        titleLabel.text = titleLabelString
        descriptionLabel.text = descriptionLabelString
    
    }
    
}
