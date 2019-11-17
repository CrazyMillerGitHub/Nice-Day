//
//  SearchTabBarController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SearchTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = true
        
        let firstViewController = RootMainViewController()
        
        firstViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Home"), tag: 0)
        firstViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let secondViewController = RootSearchViewController()
        
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Shape"), tag: 1)
        secondViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        viewControllers = [firstViewController, secondViewController]
        
    }
    
}
