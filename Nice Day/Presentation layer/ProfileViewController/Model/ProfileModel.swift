//
//  ProfileModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation

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
