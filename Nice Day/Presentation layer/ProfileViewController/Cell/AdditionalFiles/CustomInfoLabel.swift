//
//  CustomInfoLabel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 23.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class CustomInfoLabel: UILabel {
    
    enum LabelType {
        case description
        case value
    }
    
    /// Инициадизация
    /// - Parameter labelType: тип label (.description, .value)
    /// - Parameter labelText: Название текста
    init<T>(labelType: LabelType, labelText: T) {
        super.init(frame: .zero)
        contentMode = .center
        font = UIFont.systemFont(ofSize: labelType == .value ? 18 : 14, weight: labelType == .value ? .bold : .medium)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = labelType == .value ? .inverseColor : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        switch labelText {
        case is Int:
            text = "\(labelText)"
        case is String:
            if let labelText = labelText as? String { text = labelText }
        default:
            text = ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
