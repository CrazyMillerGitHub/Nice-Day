//
//  AchievmentsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AchievmentsCell: CoreCell {
    static var identifier: String = "achievments"
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? AchievmentsCellModelItem else { return }
            cellTitleLabel.text = item.titleText
        }
    }
    
    let viewModel = AchievmentViewModel()
    
    // MARK: showMoreButton
    fileprivate var showMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondGradientColor
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.setTitle("_showMore".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        return button
    }()
    
    // MARK: friendsCollectionView
       // CollectionView для статистики
       let friendsCollectionView: UICollectionView = {
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
           collectionView.backgroundColor = .red
           collectionView.register(AchievmentCell.self, forCellWithReuseIdentifier: AchievmentCell.achievmentIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
           return collectionView
       }()
       
          override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
       
    func setupViews() {
        addSubview(friendsCollectionView)
        addSubview(showMoreButton)
        friendsCollectionView.delegate = viewModel
        friendsCollectionView.dataSource = viewModel
        prepareConstraint()
    }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           setupViews()
       }
    
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            // showMoreButton constraints
            showMoreButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            showMoreButton.heightAnchor.constraint(equalToConstant: 46),
            showMoreButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            showMoreButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            // friendsCollectionView
            friendsCollectionView.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor),
            friendsCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            friendsCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            friendsCollectionView.bottomAnchor.constraint(equalTo: showMoreButton.topAnchor)
        ])
    }
    
}
