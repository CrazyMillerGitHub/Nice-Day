//
//  CoreTabBarController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/10/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class CoreTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.tabBar.layer.shadowRadius = 5
        self.tabBar.layer.shadowOpacity = 1
        self.tabBar.layer.masksToBounds = false
            }

}
