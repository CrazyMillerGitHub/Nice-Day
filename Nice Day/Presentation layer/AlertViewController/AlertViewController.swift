//
//  AlertViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 30.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet private var alertView: UIView!
    
    @IBOutlet private var actionButton: UIButton!
    
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var titleLabel: UILabel!
    
    var actionButtonString = String()
    
    var descriptionLabelString = String()
    
    var titleLabelString = String()
    
    override func viewDidLoad() {
        setupView()
        actionButton.addTarget(self, action: #selector(alertAction), for: .touchUpInside)
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(alertAction))
        gesture.direction = .down
        view.addGestureRecognizer(gesture)
    }

    @objc
    func alertAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
private extension AlertViewController {
    
    func setupView() {
        actionButton.setTitle(actionButtonString, for: .normal)
        titleLabel.text = titleLabelString
        descriptionLabel.text = descriptionLabelString
    }
    
}
