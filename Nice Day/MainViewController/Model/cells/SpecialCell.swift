//
//  SpecialCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SpecialCell: CoreCell {
    static var identifier: String = "special"
    
    var item: MainViewModelItem? {
           didSet {
               guard let item = item as? AchievmentsCellModelItem else { return }
           }
    }
    override func awakeFromNib() {
           super.awakeFromNib()
       }
}
