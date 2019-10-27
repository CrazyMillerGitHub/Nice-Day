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
    
    weak var bgView: UIView!
    
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
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.firstGradientColor.cgColor, UIColor.secondGradientColor.cgColor]
        contentView.layer.addSublayer(gradient)
    }
}
