//
//  EmotionLabel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 02.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class EmotionLabel: UIStackView {
    
    let ovalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
        label.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate func prepareConstraint() {
        NSLayoutConstraint.activate([
            ovalView.heightAnchor.constraint(equalToConstant: 6),
            ovalView.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    init(text: String = "happy") {
        super.init(frame: .zero)
        label.text = text
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 3
        backgroundColor = .green
        translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(ovalView)
        addArrangedSubview(label)
        prepareConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
