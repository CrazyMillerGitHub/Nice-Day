//
//  button+extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

extension UIButton {
    override open var isHighlighted: Bool {
               didSet {
                   if self.isHighlighted {
                       UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                           self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }, completion: nil)
                   } else {
                       UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                           self.transform = .identity
                       }, completion: nil)
                   }
               }
    }
}
