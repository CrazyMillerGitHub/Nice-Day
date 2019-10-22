//
//  CoreDataManager.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
class CoreDataManager: NSObject {
    
    var coreDataStack = CoreDataStack()
    
    override init() {
        super.init()
        self.coreDataStack.delegate = self
        
    }
    static var Instance = CoreDataManager()
}
