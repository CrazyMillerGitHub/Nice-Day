//
//  color+extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/10/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    
    class var bgColor: UIColor {
        guard let color = UIColor(named: #function) else { return UIColor() }
        return color
    }
    
    class var inverseColor: UIColor {
        guard let color = UIColor(named: #function) else { return UIColor() }
        return color
    }
    
    class var sunriseColor: UIColor {
        guard let color = UIColor(named: #function) else { return UIColor() }
        return color
    }
    
    class var searchBarColor: UIColor {
        guard let color = UIColor(named: #function) else { return UIColor() }
        return color
    }
    
    class var firstGradientColor: UIColor {
        return UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.00)
    }
    
    class var secondGradientColor: UIColor {
        return UIColor(red:0.40, green:0.70, blue:0.99, alpha:1.00)
    }
    
}
