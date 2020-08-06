//
//  StartStopButton.swift
//  Nice Day
//
//  Created by Михаил Борисов on 01.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class StartStopButton: ElasticButton {

    // MARK: - Prepare Constraint
    enum Constant: CGFloat {
        case radius = 15
        case width = 2
        case duartion = 0.6
        case spring = 0.7
        case null = 0
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.cornerRadius = Constant.radius.rawValue
        layer.borderWidth = Constant.width.rawValue
        layer.borderColor = UIColor.sunriseColor.cgColor
        layer.masksToBounds = true
        setTitle("_start".localized, for: .normal)
        setTitle("_stop".localized, for: .selected)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        setTitleColor(.sunriseColor, for: .normal)
        setTitleColor(.bgColor, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: TimeInterval(Constant.duartion.rawValue),
                           delay: TimeInterval(Constant.null.rawValue),
                           usingSpringWithDamping: Constant.spring.rawValue,
                           initialSpringVelocity: Constant.null.rawValue, options: [], animations: {
                self.backgroundColor = self.isSelected ? .sunriseColor : .bgColor
            }, completion: nil)
            
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                    self.backgroundColor = self.isSelected ? .clear : .sunriseColor
                    self.titleLabel?.textColor = self.isSelected ? .sunriseColor : .bgColor
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                    self.backgroundColor = self.isSelected ? .sunriseColor : .clear

                    self.titleLabel?.textColor = self.isSelected ? .bgColor : .sunriseColor
                }, completion: nil)
            }
        }
    }
}
