//
//  ProfileAchievmentsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class ProfileDescriptionCell: UICollectionViewCell {
    
    static var identifier = String(describing: ProfileDescriptionCell.self)

    private var presenter: ProfileDescriptionPresenter!
    
    private var bgView: UIView!
    
    // MARK: CollectionView
    // CollectionView для статистики
    private var descriptionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
       override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(descriptionCollectionView)
        presenter = ProfileDescriptionPresenter(collectionView: descriptionCollectionView, delegate: self)
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
