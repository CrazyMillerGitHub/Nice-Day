//
//  ImageView+extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 09.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

extension UIImageView {
    
  func setImageColor(_ color: UIColor) {
    
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
