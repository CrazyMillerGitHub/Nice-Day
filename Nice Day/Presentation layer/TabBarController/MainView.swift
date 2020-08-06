//
//  SearchTabBarController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainView: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(true, forKey: "loggedIn")
        let config = UIImage.SymbolConfiguration(pointSize: 18 , weight: .medium)
        self.tabBar.isTranslucent = true
        
        let firstViewController = RootMainViewController()
    
        firstViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill", withConfiguration: config)?.withBaselineOffset(fromBottom: 10), tag: 0)
        
        let secondViewController = RootSearchViewController()
        
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass", withConfiguration: config)?.withBaselineOffset(fromBottom: 10), tag: 1)
        
        viewControllers = [firstViewController, secondViewController]
        
    }
    
}
