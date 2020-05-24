//
//  StartStopButton.swift
//  Nice Day
//
//  Created by Михаил Борисов on 01.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class StartStopButton: ElasticButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.sunriseColor.cgColor
        layer.masksToBounds = true
        setTitle("Start", for: .normal)
        setTitle("Stop", for: .selected)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        setTitleColor(.sunriseColor, for: .normal)
        setTitleColor(.bgColor, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
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
