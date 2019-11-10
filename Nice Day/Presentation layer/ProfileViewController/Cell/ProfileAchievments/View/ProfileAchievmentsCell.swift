//
//  ProfileAchievmentsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileAchievmentsCell: UICollectionViewCell {
    
    static var identifier = "profileAchievments"
    
    weak var bgView: UIView!
    
    // MARK: CollectionView
    // CollectionView для статистики
    let statsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        reset()
        contentView.addSubview(statsCollectionView)
        statsCollectionView.register(MoodStaticCell.self, forCellWithReuseIdentifier: MoodStaticCell.identifier)
        statsCollectionView.delegate = self
        statsCollectionView.dataSource = self
        statsCollectionView.frame = contentView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.firstGradientColor.cgColor, UIColor.secondGradientColor.cgColor]
        contentView.layer.addSublayer(gradient)
    }
}
extension ProfileAchievmentsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodStaticCell.identifier, for: indexPath) as? MoodStaticCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0...1:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 130)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 30, height: 236)
        }
    }
    
}
