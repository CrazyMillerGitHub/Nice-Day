//
//  MainViewControllerProvider.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewControllerProvider: NSObject ,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else { fatalError("Error with cell") }
        cell.backgroundColor = .black
        return cell
    }
   
}
