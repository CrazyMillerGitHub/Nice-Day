//
//  NewFriendTitleLabel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class NewFriendTitleLabel: UILabel {
    
    init(of titleText:String) {
        super.init(frame: .zero)
        contentMode = .left
        tintColor = .black
        text = titleText
        font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
