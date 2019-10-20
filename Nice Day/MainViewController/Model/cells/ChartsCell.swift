//
//  ChartsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ChartsCell: CoreCell {
    static var identifier: String = "charts"
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? ChartsCellModelItem else { return }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
