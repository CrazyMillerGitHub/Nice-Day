//
//  CustomStackView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 23.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class CustomStackView: UIStackView {
    
    /// Инициализация
    /// - Parameter elements: elements that we use in our stackView(may be UIView, etc)
    /// - Parameter stackViewAxis: Axis of StackView(.vertical, .horizontal)
    /// - Parameter spacingCount: spacing between elements
    init(elements: [UILabel]?, stackViewAxis: NSLayoutConstraint.Axis, spacingCount: CGFloat) {
        super.init(frame: .zero)
        axis = stackViewAxis
        distribution = .equalSpacing
        alignment = .center
        spacing = spacingCount
        translatesAutoresizingMaskIntoConstraints = false
        if let elements = elements { elements.forEach { addArrangedSubview($0) } }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
