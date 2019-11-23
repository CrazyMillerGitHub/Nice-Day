//
//  AchievmentsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AchievmentsCell: CoreCell, UICollectionViewDelegate, UICollectionViewDataSource {
    static var identifier: String = "achievments"
    
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
        friendsCollectionView.register(AchievmentCell.self, forCellWithReuseIdentifier: AchievmentCell.achievmentIdentifier)
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("jej")
          return 1
      }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("SSSS")
        return 3
    }
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievmentCell.achievmentIdentifier, for: indexPath) as? AchievmentCell else { fatalError() }
          return cell
      }
    
}
