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
        guard let color = UIColor(named: "bgColor") else { fatalError() }
        return color
    }
    class var inverseColor: UIColor {
        guard let color = UIColor(named: "inverseColor") else { fatalError() }
        return color
    }
}
