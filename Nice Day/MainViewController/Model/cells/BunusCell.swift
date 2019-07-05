//
//  BunusCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class BunusCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        shadow()
    }
    
    /// Создание тени под cell
    func shadow() {
        self.layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.16).cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 16
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize(width: 0, height: 16)

    }
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                    self.transform = .identity
                }, completion: nil)
            }
        }
    }
}
