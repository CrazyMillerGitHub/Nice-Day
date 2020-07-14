//
//  ProfileModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

struct ProfileModel {

    let firstName: String
    let lastName: String
    let xpCount: Int
    let level: Int
    
    init() {
        // TODO: Fetch UserInfo here
        self.firstName = "Apple"
        self.lastName = "Feld"
        self.xpCount = 150
        self.level = 10
    }
    
}
