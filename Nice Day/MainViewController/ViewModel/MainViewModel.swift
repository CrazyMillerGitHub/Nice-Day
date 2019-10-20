//
//  MainViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

enum MainViewModelItemType {
    case charts
    case bonus
    case friend
    case mood
    case achievments
    case special
}

protocol MainViewModelItem {
    var type: MainViewModelItemType { get }
    var rowCount: Int { get }
}

extension MainViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class ChartsCellModelItem: MainViewModelItem {
    var type: MainViewModelItemType {
        return .achievments
    }
}

class BonusCellModelItem: MainViewModelItem {
    var type: MainViewModelItemType {
        return .bonus
    }
}

class FriendsCellModelItem: MainViewModelItem {
    var type: MainViewModelItemType {
        return .friend
    }
}

class MoodCellModelItem: MainViewModelItem {
    var type: MainViewModelItemType {
        return .mood
    }
}

class AchievmentsCellModelItem: MainViewModelItem {
    var type: MainViewModelItemType {
        return .achievments
    }
}

class SpecialCellModelItem: MainViewModelItem {
    var type: MainViewModelItemType {
        return .special
    }
}

class MainViewModel: NSObject {
    var items = [MainViewModelItem]()
    
    var data: MainViewControllerData = {
        let data = MainViewControllerData.shared
        return data
    }()
    
    override init() {
        super.init()
        
        let chartsItem = ChartsCellModelItem()
        items.append(chartsItem)
        
        let bonusItem = BonusCellModelItem()
        items.append(bonusItem)
        
        let friendsItem = FriendsCellModelItem()
        items.append(friendsItem)
        
        let moodItem = MoodCellModelItem()
        items.append(moodItem)
        
        let acheivmentItem = AchievmentsCellModelItem()
        items.append(acheivmentItem)
        
        let specialItem = SpecialCellModelItem()
        items.append(specialItem)
    }
}
extension MainViewModel:  UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items[section].rowCount)
        return items[section].rowCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .achievments:
            print(AchievmentsCell.identifier)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievmentsCell.identifier, for: indexPath) as? AchievmentsCell else { fatalError() }
                cell.item = item
            cell.backgroundColor = .white
                return cell
            
        case .bonus:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BonusCell.identifier, for: indexPath) as? BonusCell {
                cell.item = item
                return cell
            }
        case .special:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialCell.identifier, for: indexPath) as? SpecialCell {
                cell.item = item
                return cell
            }
        case .charts:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsCell.identifier, for: indexPath) as? ChartsCell {
                cell.item = item
                return cell
            }
        case .friend:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell {
                cell.item = item
                return cell
            }
        case .mood:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodCell.identifier, for: indexPath) as? MoodCell {
                cell.item = item
                return cell
            }
        }
        return UICollectionViewCell()
    }
   
}
