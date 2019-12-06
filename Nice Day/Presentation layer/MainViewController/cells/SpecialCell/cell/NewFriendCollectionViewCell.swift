//
//  NewFriendCollectionViewCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class NewFriendCollectionViewCell: UICollectionViewCell {
    
    // MARK: newFriendImage init
    private var newFriendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "emoji3")
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareUI()
    }
    
    
    
}
private extension NewFriendCollectionViewCell {
    
    // MARK: prepareUI (настройка UI)
    func prepareUI() {
        refresh()
        prepareConstraint()
    }
    
    func refresh() {
        contentView.addSubview(newFriendImage)
        
    }
    
    func prepareConstraint() {
        NSLayoutConstraint.activate([
            // newFriendImage Constraint
            newFriendImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            newFriendImage.centerYAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>, constant: <#T##CGFloat#>)
        ])
    }
}
