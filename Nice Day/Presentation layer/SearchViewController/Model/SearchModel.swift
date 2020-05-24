//
//  SearchModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 29.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

struct ActivityElement: Hashable, Equatable {
    
    static func == (lhs: ActivityElement, rhs: ActivityElement) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    let identifier = UUID()
    let name: String
    let xpCount: Int
    let category: Grade

}

extension ActivityElement {

    static var elements: [ActivityElement] = [
        ActivityElement(name: "Watching TV", xpCount: 10, category: .passive),
        ActivityElement(name: "Playing Games", xpCount: 30, category: .active),
        ActivityElement(name: "Volleyball", xpCount: 33, category: .active),
        ActivityElement(name: "Basketball", xpCount: 22, category: .active),
        ActivityElement(name: "Rollercast", xpCount: 11, category: .active),
        ActivityElement(name: "Table tennis", xpCount: 12, category: .active),
        ActivityElement(name: "Chess", xpCount: 20, category: .passive),
        ActivityElement(name: "Shopping", xpCount: 32, category: .passive),
        ActivityElement(name: "Workout", xpCount: 33, category: .active)
    ]
}
