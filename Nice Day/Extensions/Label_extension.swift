//
//  Label_extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06.01.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     Добавляет текст с аттрибутами для поиска

    - Parameters:
       - for: Значение активности, которое будет отображаться в Cell
    */
    func setAttributedStringForSearch(for xpCount: Int) {
        let str = "\(xpCount) xp every minute"
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
            .foregroundColor: UIColor.inverseColor,
            .kern: -0.29
        ])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 12.0, weight: .bold),
            .foregroundColor: UIColor.green
        ], range: NSRange(location: String(xpCount).count + 1, length: 2))
        self.attributedText = attributedString
    }
    
}
