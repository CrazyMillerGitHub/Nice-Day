//
//  InterfaceController.swift
//  Nice Day Watch Extension
//
//  Created by Михаил Борисов on 21.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet private var tableRow: WKInterfaceTable!
    
    let names = ["Matthew", "Mark"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
