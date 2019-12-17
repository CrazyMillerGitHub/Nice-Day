//
//  AchievmentsStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 13.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AchievmentsStaticCell: CoreCell {
    
    static let identifier = "achievmnetsStaticCell"
    
    // MARK: achievmentCollectionView
    // CollectionView для наград
    let achievmentCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AchievmentStaticCell.self, forCellWithReuseIdentifier: AchievmentStaticCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        achievmentCollectionView.frame = contentView.frame
        achievmentCollectionView.delegate = self
        achievmentCollectionView.dataSource = self
        contentView.addSubview(achievmentCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AchievmentsStaticCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievmentStaticCell.identifier, for: indexPath) as?  AchievmentStaticCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 27, bottom: 27, right: 27)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
}
