//
//  MainViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

struct MainItem: Hashable, Equatable {

    enum ItemsType: String, CaseIterable {
        case charts, bonus, friend, mood, achievments, special

        func size() -> CGSize {
            switch self {
                
            case .bonus, .mood, .special:
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 130)
            case .friend:
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 186)
            default:
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 236)
            }
        }
    }

    let identifier = UUID()

    let type: ItemsType

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: MainItem, rhs: MainItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
