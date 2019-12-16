//
//  ProfileAchievmentsViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 24.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

enum ProfileAchievmentsViewModelItemType {
    case mood
    case charts
    case achievments
}

protocol ProfileAchievmentsViewModelItem {
    var type: ProfileAchievmentsViewModelItemType { get }
}

class MoodProfileModelItem: ProfileAchievmentsViewModelItem {
    
    var item: String {
        return "_mood".localized()
    }
    
    var type: ProfileAchievmentsViewModelItemType {
        return .mood
    }
}

class ChartsProfileModelItem: ProfileAchievmentsViewModelItem {
    
    var item: String {
        return "_charts".localized()
    }
    
    var type: ProfileAchievmentsViewModelItemType {
        return .charts
    }
}

class AchievmentsProfileModelItem: ProfileAchievmentsViewModelItem {
    
    var item: String {
        return "_achievments".localized()
    }
    
    var type: ProfileAchievmentsViewModelItemType {
        return .achievments
    }
}
class ProfileAchievmentsViewModel: NSObject {
    var items = [ProfileAchievmentsViewModelItem]()
    
    override init() {
        super.init()
        
        let mood = MoodProfileModelItem()
        items.append(mood)
        
        let charts = ChartsProfileModelItem()
        items.append(charts)
        
        let achievments = AchievmentsProfileModelItem()
        items.append(achievments)
        
    }
}

extension ProfileAchievmentsViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        switch item.type {
        case .mood:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodStaticCell.identifier, for: indexPath) as? MoodStaticCell {
                cell.run(mode: .analyz, text: "_mood".localized())
                return cell
            }
        case _:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsStaticCell.identifier, for: indexPath) as? ChartsStaticCell {
                cell.run(mode: .analyz, text: "_charts".localized())
                return cell
            }
//        case .achievments:
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodStaticCell.identifier, for: indexPath) as? MoodStaticCell {
//                cell.run(mode: .analyz, text: "_achievments".localized())
//            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.row]
        switch item.type {
        case .mood:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 130)
        case .charts:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 180)
        case .achievments:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 410)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 28, left: 15, bottom: 28, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 33
    }
    
}
