//
//  EmailView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 27.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class EmailView: UIViewController {
    @IBOutlet private var forgotButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotButton.addTarget(self, action: #selector(forgotAction), for: .touchUpInside)
    }
    
    @objc
    private func forgotAction() {
        let supportVC = SupportView()
        supportVC.modalPresentationStyle = .fullScreen
        self.present(supportVC, animated: true, completion: nil)
    }
}
