//
//  MoodStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 10.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import PassKit

class MoodStaticCell: CoreCell {
    
    static var identifier = "moodStaticCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.addArrangedSubview(EmotionLabel(text: "Happy"))
        stackView.addArrangedSubview(EmotionLabel(text: "Normal"))
        stackView.addArrangedSubview(EmotionLabel(text: "Sad"))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor,constant: 34.5),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
