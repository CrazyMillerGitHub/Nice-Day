//
//  EmailSupportCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
class EmailSupportCell: CoreSupportCell {
    static var identifier = "EmailSupportCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    var item: SupportViewModelItem? {
        didSet {
            guard let item = item as? SupportEmailModelItem else {
                return
            }
            stageTitleLabel.text = item.item
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
