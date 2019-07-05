//
//  MainViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let provider = MainViewControllerProvider()
    let delegate = MainViewControllerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = provider
        collectionView.delegate = delegate
        self.title = "Nice Day"
        // Do any additional setup after loading the view.
    }

}
