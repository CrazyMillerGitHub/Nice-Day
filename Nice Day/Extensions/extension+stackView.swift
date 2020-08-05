//
//  extension+stackView.swift
//  Stack_test
//
//  Created by Михаил Борисов on 09.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

extension UIStackView {

    // MARK: ContainerStackView
    static var container: UIStackView {
        // inizialization stackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        // setted distributon to equal spacing
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alpha = 0
        // hide stackView
        // setted to perform constraints later
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

}

extension UIView {
    
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        // create constraint
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: value)
        self.addConstraint(constraint)
    }
    
}
