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

    // MARK: CollectionView
    // CollectionView для статистики
    private lazy var descriptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).with { collectionView in
        collectionView.backgroundColor = .clear
    }
    
       override init(frame: CGRect) {
        super.init(frame: frame)

        DispatchQueue.main.async { [unowned self] in
            self.setupViews()
        }
    }
    
    func setupViews() {
        presenter = ProfileDescriptionPresenter(collectionView: descriptionCollectionView, delegate: self)
        addGradientLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.firstGradientColor.cgColor, UIColor.secondGradientColor.cgColor]
        contentView.layer.insertSublayer(gradient, at: 0)
    }
}
