//
//  RootSearchViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 22.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class RootSearchViewController: UINavigationController {

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        let searchView = SearchView()
        viewControllers = [searchView]
    }
    
}
