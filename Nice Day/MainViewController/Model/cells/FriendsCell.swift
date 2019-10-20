//
//  FriendsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class FriendsCell: CoreCell {
    static var identifier: String = "friends"
    
    var item: MainViewModelItem? {
           didSet {
               guard let item = item as? FriendsCellModelItem else { return }
           }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
