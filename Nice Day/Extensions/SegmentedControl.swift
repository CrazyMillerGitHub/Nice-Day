//
//  SegmentedControl.swift
//  Nice Day
//
//  Created by Михаил Борисов on 09.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
class SquareSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
        layer.backgroundColor = UIColor.white.cgColor
    }
}
