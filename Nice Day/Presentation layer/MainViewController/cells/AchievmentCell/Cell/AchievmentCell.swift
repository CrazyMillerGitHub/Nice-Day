//
//  FriendCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AchievmentCell: UICollectionViewCell {
    static var achievmentIdentifier = "AchievmentCell"
    
       override init(frame: CGRect) {
           super.init(frame: frame)
           refresh()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           refresh()
       }
       
       private func refresh() {
       }
}
