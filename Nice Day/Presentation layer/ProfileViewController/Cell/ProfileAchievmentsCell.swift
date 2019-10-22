//
//  ProfileAchievmentsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileAchievmentsCell: UICollectionViewCell {
    
    static var identifier = "profileAchievments"
    
    fileprivate let firstGradientColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.00)
    fileprivate let secondGradientColor = UIColor(red:0.40, green:0.70, blue:0.99, alpha:1.00)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        reset()
    }
    private func reset() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstGradientColor, secondGradientColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.contentView.bounds
        self.contentView.layer.insertSublayer(gradientLayer, at:0)
    }
}
