//
//  File.swift
//  Nice Day
//
//  Created by Михаил Борисов on 07.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
class NewPasswordAgain: CoreSupportCell {
    static var identifier = "NewPasswordAgain"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    var item: SupportViewModelItem? {
        didSet {
            guard let item = item as? NewPassworAgainModelItem else {
                return
            }
            stageTitleLabel.text = item.item
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

