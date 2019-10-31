//
//  SupportCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 28.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SupportCell: UITableViewCell {
    
    static var identifier = "supportCell"
    
    // MARK: stageLabel
    let stageLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .sunriseColor
        label.layer.backgroundColor = UIColor.black.cgColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        reset()
        NSLayoutConstraint.activate([
        
            stageLabel.heightAnchor.constraint(equalToConstant: 34.0),
            stageLabel.widthAnchor.constraint(equalToConstant: 34.0),
            stageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 34),
            stageLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 34)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        addSubview(stageLabel)
    }
}
