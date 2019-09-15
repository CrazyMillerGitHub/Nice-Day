//
//  colors.swift
//  Nice Day
//
//  Created by Михаил Борисов on 15/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    @nonobjc class var bgColor: UIColor {
          guard let color = UIColor(named: "bgColor") else { fatalError() }
          return color
      }
}
