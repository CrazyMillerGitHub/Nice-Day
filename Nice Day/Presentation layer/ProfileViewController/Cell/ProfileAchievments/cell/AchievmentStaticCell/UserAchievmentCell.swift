//
//  AchievmentsStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 13.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class UserAchievmentCell: CoreCell, UserAchievmentCallable {
    
    static let identifier = String(describing: UserAchievmentCell.self)

    private var presenter: UserAchievmentPresenter!
    
    // MARK: achievmentCollectionView
    // CollectionView для наград
    private lazy var achievmentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).with { collectionView in
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        DispatchQueue.main.async { [unowned self] in
            self.presenter = UserAchievmentPresenter(collectionView: self.achievmentCollectionView, delegate: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
