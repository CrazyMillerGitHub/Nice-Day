//
//  MainViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    let arr = [1, 2, 3]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else { fatalError("Error with cell") }
        cell.backgroundColor = .black
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0, options: [], animations: {
            self.collectionView.cellForItem(at: indexPath)?.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(indexPath.row)
        switch arr[indexPath.row] {
        case 1:
            return CGSize(width: view.frame.width - 30, height: 130)
        case 2:
            return CGSize(width: view.frame.width - 30, height: 130)
        default:
            return CGSize(width: view.frame.width - 30, height: 236)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }

}
