//
//  AchievmentStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 17.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AchievmentStaticCell: UICollectionViewCell {
    
    static let identifier = "achievmnetStaticCell"
    
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
    
}
private extension AchievmentStaticCell {
    
    func refresh() {
        contentView.layer.backgroundColor = UIColor.searchBarColor.cgColor
        contentView.layer.cornerRadius = contentView.frame.width / 2
    }
}
