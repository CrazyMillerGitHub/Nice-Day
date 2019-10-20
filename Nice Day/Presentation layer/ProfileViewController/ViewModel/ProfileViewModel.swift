//
//  ProfileViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit

enum ProfileViewModelItemType {
    case about
    case achievments
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
}

class AboutCellModelItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .about
    }
}

class ProfileAchievmentsModelItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .achievments
    }
}

class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItem]()
    
    override init() {
        super.init()
        
        let aboutItem = AboutCellModelItem()
        items.append(aboutItem)
        
        let achievmentItem = ProfileAchievmentsModelItem()
        items.append(achievmentItem)
        
    }
}
extension ProfileViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .about:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .red
            return cell
        case .achievments:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileAchievmentsCell.identifier, for: indexPath) as? ProfileAchievmentsCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        }
    }
}
extension ProfileViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.section]
        switch item.type {
        case .about:
             return CGSize(width: collectionView.bounds.width, height: 400)
        case .achievments:
             return CGSize(width: collectionView.bounds.width, height: 400)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
