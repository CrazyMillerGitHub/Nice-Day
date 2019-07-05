//
//  MainViewControllerProvider.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewControllerProvider: NSObject ,UICollectionViewDataSource {

    var data: MainViewControllerData = {
        let data = MainViewControllerData.shared
        return data
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0...1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "big_cell", for: indexPath) as? ChartsCell else { fatalError("Error with cell") }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "small_cell", for: indexPath) as? BunusCell else { fatalError("Error with cell") }
            return cell
        }
    }
   
}
