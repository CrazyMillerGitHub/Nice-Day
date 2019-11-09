//
//  CoreCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/10/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class CoreCell: UICollectionViewCell {
    
    // MARK: stageTitleLabel
    // Название ячейки
    let cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    func reset() {
        contentView.addSubview(cellTitleLabel)
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .white
        self.contentView.clipsToBounds = false
        self.contentView.layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.16).cgColor
        self.contentView.layer.shadowOpacity = 0.9
        self.contentView.layer.shadowRadius = 16
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 16)
        self.contentView.layer.masksToBounds = false
        NSLayoutConstraint.activate([
            
            cellTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cellTitleLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                    self.transform = .identity
                }, completion: nil)
            }
        }
    }
}
