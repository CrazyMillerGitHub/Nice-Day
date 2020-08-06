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
