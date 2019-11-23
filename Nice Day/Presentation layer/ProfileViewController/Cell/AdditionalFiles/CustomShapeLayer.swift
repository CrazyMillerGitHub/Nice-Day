//
//  CustomShapeLayer.swift
//  Nice Day
//
//  Created by Михаил Борисов on 23.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProgressShapeLayer: CAShapeLayer {
    
    enum ShapeType {
        case background
        case foreground
    }
    
    init(shapePath: CGPath, shapeType: ShapeType) {
        super.init()
        path = shapePath
        strokeColor = shapeType == .foreground ? UIColor.white.cgColor : UIColor.sunriseColor.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidth = shapeType == .foreground ? 10 : 9
        if (shapeType == .foreground) {
            strokeEnd = 0
            shadowColor = UIColor.black.cgColor
            shadowRadius = 8
            shadowOffset = CGSize(width: 0, height: 4)
            shadowOpacity = 0.1
            lineCap = .round
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
