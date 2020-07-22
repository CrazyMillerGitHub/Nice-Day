//
//  CoreCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 05/10/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class CoreCell: UICollectionViewCell {
    
    enum StatusCell {
        case main
        case analyz
    }

    internal var currentUser: User!

    var status: Bool = false
    
    // MARK: stageTitleLabel
    // Название ячейки
    let cellTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .inverseColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: cellDescriptionLabel
    // Название ячейки
    let cellDescriptionLabel: (String) -> UILabel = { str in
        let label = UILabel()
        label.text = "\(str)   "
        label.textAlignment = .center
        label.textColor = .inverseColor
        label.layer.backgroundColor = UIColor.bgColor.cgColor
        label.layer.cornerRadius = 18
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 10)
        label.layer.shadowRadius = 20
        label.layer.shadowOpacity = 0.1
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareForUse()
    }
    
    fileprivate func analyzLabel(_ text: String) {
        let label = cellDescriptionLabel(text)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -9),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -18),
            label.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func run(mode: StatusCell, text: String, user: User) {
        switch mode {
        case .analyz:
            analyzLabel(text)
            self.currentUser = user
        case _:
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepareForUse()
    }
    
    private func prepareForUse() {
        contentView.addSubview(cellTitleLabel)
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .cellBackgroundColor
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
            UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) :  .identity
            }, completion: nil )
        }
    }
}
