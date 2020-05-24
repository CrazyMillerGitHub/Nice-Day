//
//  Label_extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06.01.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

extension UILabel {
    
    // MARK: Splash Label
    static var splash: UILabel {
        // Inizialize label with size: height - 60, width - width of screen
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        // Set default text to "Nice Day"
        label.text = "Nice Day"
        // Set aligment to center
        label.textAlignment = .center
        // Use the huge font
        label.font = UIFont.systemFont(ofSize: 56, weight: .heavy)
        // Set text color to sunrize color
        label.textColor = UIColor(red: 1.00, green: 0.18, blue: 0.33, alpha: 1.0)
        label.alpha = 0
        return label
    }

    // MARK: forgotPassword Label
    static var forgotPassword: UILabel {
        // Inizialize label
        let label = UILabel()
        // set label text to localized
        label.text = "_forgotPassword".localized
        // set aligment to right
        label.textAlignment = .right
        // font to semibold SF size 16 pt
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        // set label color
        label.textColor = .white
        // set label as user iteraction
        label.isUserInteractionEnabled = true
        // disable autoconstraint
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // MARK: title label
    static var title: UILabel {
        // inizialize label
        let label = UILabel()
        // disable auto-constraint
        label.translatesAutoresizingMaskIntoConstraints = false
        // set text
        label.text = "Nice Day"
        // text color
        label.textColor = .inverseColor
        // set alignment to left
        label.textAlignment = .left
        // set font
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        return label
    }
    
    // MARK: description label
    static var description: UILabel {
        // inizialize label
        let label = UILabel()
        // disable auto-constraint
        label.translatesAutoresizingMaskIntoConstraints = false
        // text color
        label.textColor = .inverseColor
        // set text
        label.text = "Be better every day!"
        // set alignment to left
        label.textAlignment = .left
        // set font
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }
    
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
