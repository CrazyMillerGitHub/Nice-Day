//
//  EmotionCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 10.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class EmotionCell: UICollectionViewCell {
    
    static var identifier = "emotionCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
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
        imageView.frame = contentView.frame
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 29
        contentView.layer.masksToBounds = false
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowColor = UIColor.black.cgColor
    }
}
