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
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 5, height: 5)))
        view.layer.backgroundColor = UIColor.red.cgColor
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
    
    init(text: String = "happy") {
        super.init(frame: .zero)
        label.text = text
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 3
        backgroundColor = .green
        translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(label)
        addArrangedSubview(ovalView)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
