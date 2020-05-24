//
//  CustomShapeLayer.swift
//  Nice Day
//
//  Created by Михаил Борисов on 23.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class ProgressShapeLayer: CAShapeLayer {
    
    enum ShapeType {
        case background
        case foreground
        case moodBackground
        case moodForeground
    }
    
    init(shapePath: CGPath, shapeType: ShapeType, from startValue: CGFloat = 1.0) {
        super.init()
        path = shapePath
        fillColor = UIColor.clear.cgColor
        strokeEnd = startValue
        (strokeColor, lineWidth) = performShape(shapeType: shapeType)
        if (shapeType == .foreground || shapeType == .moodForeground) {
            strokeEnd = 0
            shadowColor = UIColor.black.cgColor
            shadowRadius = 8
            shadowOffset = CGSize(width: 0, height: 4)
            shadowOpacity = 0.1
            lineCap = .round
        }
    }
    
    private func performShape(shapeType: ShapeType) -> (color :CGColor, width: CGFloat) {
        switch shapeType {
        case .foreground:
            return (UIColor.foregroundColor.cgColor, 10)
        case .background:
            return (UIColor.sunriseColor.cgColor, 9)
        case .moodBackground:
            return (#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1).cgColor,4)
        case .moodForeground:
            return(#colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1).cgColor,5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
