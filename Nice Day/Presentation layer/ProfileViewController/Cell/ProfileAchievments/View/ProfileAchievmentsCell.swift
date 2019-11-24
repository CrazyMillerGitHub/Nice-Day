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
    
    fileprivate let viewModel = ProfileAchievmentsViewModel()
    
    weak var bgView: UIView!
    
    // MARK: CollectionView
    // CollectionView для статистики
    let statsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(MoodStaticCell.self, forCellWithReuseIdentifier: MoodStaticCell.identifier)
        return collectionView
    }()
    
       override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(statsCollectionView)
        
        statsCollectionView.delegate = viewModel
        statsCollectionView.dataSource = viewModel
        
        statsCollectionView.frame = contentView.frame
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        setupViews()
    }
    
    private func reset() {
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.firstGradientColor.cgColor, UIColor.secondGradientColor.cgColor]
        contentView.layer.addSublayer(gradient)
    }
}
