//
//  MainViewControllerDelegate.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewControllerDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let arr = [1, 2, 3]
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hello world")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(indexPath.row)
        switch arr[indexPath.row] {
        case 1:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 130)
        case 2:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 130)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 236)
        }
    }
    
}
