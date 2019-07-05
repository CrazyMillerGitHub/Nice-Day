//
//  ChartsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ChartsCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
       shadow()
    }
    
    /// Создание тени под cell
    func shadow() {
        backgroundColor = UIColor(red:0.40, green:0.70, blue:0.99, alpha:1.00)
        self.layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.3).cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.9
        self.layer.cornerRadius = 15
    
        self.layer.shadowPath = CustomShadowClass.instance.shadow(height: 236)

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

class CustomShadowClass {
    static var instance = CustomShadowClass()
    private init() {}
    func shadow(height: Int) -> CGPath {
        let contactShadowSize: CGFloat = 15
        let yRes: CGFloat = CGFloat(height - 5)
        let shadowPath = CGPath(ellipseIn: CGRect(x: 20, y: yRes, width: UIScreen.main.bounds.width - 68, height: contactShadowSize), transform: nil)
        return shadowPath
    }
}
