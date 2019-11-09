//
//  MoodCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MoodCell: CoreCell {
    
    static var identifier: String = "mood"
    
    var item: MainViewModelItem? {
           didSet {
               guard let item = item as? MoodCellModelItem else { return }
           }
    }
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .sunriseColor
        button.setImage(UIImage(named: "Home"), for: .normal)
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.sunriseColor.cgColor
        button.layer.shadowRadius = 16.0
        button.layer.shadowOpacity = 0.14
        button.layer.shadowOffset = CGSize(width: 0, height: 16)
        button.layer.masksToBounds = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 46),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
