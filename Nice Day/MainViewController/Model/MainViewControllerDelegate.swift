//
//  MainViewControllerDelegate.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewControllerDelegate: NSObject, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var data: MainViewControllerData = {
        let data = MainViewControllerData.shared
        return data
    }()
    weak var delegate: ProfileImageViewProtocol?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (data.arr.contains(1) && indexPath.row == 1) {
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
                data.arr.remove(at: indexPath.row)
            }, completion:nil)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.moveAndResizeImage()
//        moveAndResizeImage(for: height)
    }
    /// Изменения размера ячейки при различной последовательности
    ///
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - collectionViewLayout: collectionViewLayout
    ///   - indexPath: indexPath
    /// - Returns: размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 236)
    }
}
protocol ProfileImageViewProtocol: class {
    func moveAndResizeImage()
}
