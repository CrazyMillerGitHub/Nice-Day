//
//  SpecialCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SpecialCell: CoreCell {
    
    static var identifier: String = "special"
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? SpecialCellModelItem else { return }
            cellTitleLabel.text = item.titleText
        }
    }
    
    private var quoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .black
        label.text = "One step for human, big step for civilization"
        label.contentMode = .center
        return label
    }()
    
    private var quoreAuthor: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .black
        label.text = "Nile Armstrong"
        label.contentMode = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refresh() {
        addSubview(quoreLabel)
        addSubview(quoreAuthor)
        NSLayoutConstraint.activate([
            quoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            quoreAuthor.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quoreAuthor.topAnchor.constraint(equalTo: quoreLabel.bottomAnchor,constant: 18)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
