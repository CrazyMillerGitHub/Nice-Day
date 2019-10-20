//
//  BunusCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class BonusCell: CoreCell {
    static var identifier: String = "bonus"
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? BonusCellModelItem else { return }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
