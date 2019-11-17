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
    
    var friendViewModel = AchievmentViewModel()
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? AchievmentsCellModelItem else { return }
            cellTitleLabel.text = item.titleText
        }
    }
    
    let friendsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: FriendCell.identifier)
        return collectionView
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        refresh()
    }
    
    private func refresh() {
        addSubview(showMoreButton)
        addSubview(friendsCollectionView)
        prepareConstraint()
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
extension AchievmentsCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell else { fatalError() }
        print("Tuta")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 58, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 50, bottom: 0, right: 10)
    }
}
