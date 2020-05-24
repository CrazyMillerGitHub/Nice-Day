//
//  NewFriendCollectionViewCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class NewFriendCollectionViewCell: UICollectionViewCell {
    
    static var identifer = "newFriendC"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
}
