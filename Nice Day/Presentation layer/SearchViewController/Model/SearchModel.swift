//
//  SearchModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 29.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

struct SearchElement {
    
    let name: String
    let xpCount: Int
    let category: GradeStatus
}

class SearchModel: NSObject {
    
    var arr = ["Sport", "Volleyboll", "Basketball", "Tennis", "Jerking", "Football", "Chess", "Study"]
    
    var array = [SearchElement]()
    
    override init() {
        super.init()
        arr.forEach { self.array.append(SearchElement(name: $0, xpCount: Int.random(in: 0...100), category: GradeStatus.allCases.randomElement() ?? .active)) }
    }
    
}
