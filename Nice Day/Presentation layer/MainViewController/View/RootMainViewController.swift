//
//  RootMainViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class RootMainViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = MainViewController()
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        viewControllers = [mainViewController]
        
    }
    
}
