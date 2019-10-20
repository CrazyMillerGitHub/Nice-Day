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
        
        let firstViewController = RootMainViewController()
        
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        
        let secondViewController = SearchView()
        
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        viewControllers = [secondViewController, firstViewController]
        
    }
    
}
