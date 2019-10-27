//
//  SearchCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    static var identifier: String = "Cell"
    
    // MARK: textLabel
    let textTitle: UILabel = {
        let label = UILabel()
        label.text = "LoremIpsum"
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: DescriptionLabel
    let dscrTitle: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "0,20 xp every minute", attributes: [
          .font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
          .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
          .kern: -0.29
        ])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 12.0, weight: .medium),
            .foregroundColor: UIColor.green
             ], range: NSRange(location: 5, length: 2))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: StackView
    let stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .bgColor
        self.accessoryType = .disclosureIndicator
        stackView.addArrangedSubview(dscrTitle)
         stackView.addArrangedSubview(textTitle)
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 1),
            stackView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
