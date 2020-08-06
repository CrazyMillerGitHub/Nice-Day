//
//  UserAchievmentPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 28.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol UserAchievmentCallable: UICollectionViewCell {
}

final class UserAchievmentPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    enum Constants {

        case size, items, insertTop, insertBottom, insertLeft, insertRight, spacing

        var value: CGFloat {
            switch self {
            case .size:
                return 48
            case .items:
                return 24
            case .insertTop:
                return 25
            case .insertLeft, .insertRight, .insertBottom:
                return 27
            case .spacing:
                return 24
            }
        }
    }

    private weak var delegate: UserAchievmentCallable?

    private var collectionView: UICollectionView

    init(collectionView: UICollectionView, delegate: UserAchievmentCallable) {
        self.delegate = delegate
        self.collectionView = collectionView
        super.init()
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.register(AchievmentStaticCell.self, forCellWithReuseIdentifier: AchievmentStaticCell.identifier)
        collectionView.frame = delegate?.contentView.frame ?? .zero
        collectionView.delegate = self
        collectionView.dataSource = self
        delegate?.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Constants.items.value)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievmentStaticCell.identifier, for: indexPath) as?  AchievmentStaticCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.size.value, height: Constants.size.value)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.insertTop.value,
                            left: Constants.insertLeft.value,
                            bottom: Constants.insertBottom.value,
                            right: Constants.insertRight.value)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing.value
    }
}
