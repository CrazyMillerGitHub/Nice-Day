//
//  File.swift
//  Nice Day
//
//  Created by Михаил Борисов on 07.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
class FiveDigitCell: CoreSupportCell {
    
    static var identifier = "FiveDigitCell"
    
    weak var collectionView: UICollectionView!
    
    let digitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.layer.backgroundColor = UIColor.searchBarColor.cgColor
        return textField
    }()
    
    // MARK: stackview init
    fileprivate let stackView: (UITextField) -> UIStackView = { textField in
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(textField)
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let digitStackView = stackView(digitTextField)
        contentView.addSubview(digitStackView)
        
        NSLayoutConstraint.activate([
            
            digitTextField.heightAnchor.constraint(equalToConstant: 37),
            digitTextField.widthAnchor.constraint(equalToConstant: 37),
            
            digitStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            digitStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            digitStackView.heightAnchor.constraint(equalToConstant: 60),
            digitTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    var item: SupportViewModelItem? {
        didSet {
            guard let item = item as? FiveDigitKeyModelItem else {
                return
            }
            stageTitleLabel.text = item.item
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
