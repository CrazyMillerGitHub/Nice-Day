//
//  ProfileDescriptionPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 22.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

final class ProfileDescriptionPresenter: NSObject {

    private let collectionView: UICollectionView

    internal weak var delegate: UICollectionViewCell?

    private lazy var items: [ProfileAchievmentsViewModelItem] = {
        
        return [MoodProfileModelItem(),
                ChartsProfileModelItem(),
                AchievmentsProfileModelItem()]
    }()

    init(collectionView: UICollectionView, delegate: UICollectionViewCell) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        configureCollectionView()
    }

    private let currentUser: User = {
        return CoreDataManager.shared.currentUser(CoreDataManager.shared.context(on: .main))
    }()

    private func configureCollectionView() {
        collectionView.frame = delegate?.contentView.frame ?? .zero
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoodStaticCell.self, forCellWithReuseIdentifier: MoodStaticCell.identifier)
        collectionView.register(ChartsStaticCell.self, forCellWithReuseIdentifier: ChartsStaticCell.identifier)
        collectionView.register(AchievmentsStaticCell.self, forCellWithReuseIdentifier: AchievmentsStaticCell.identifier)
    }
}

extension ProfileDescriptionPresenter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return items.count
     }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let mainContext = CoreDataManager.shared.context(on: .main)
        switch item.type {
        case .mood:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodStaticCell.identifier, for: indexPath) as? MoodStaticCell {
                mainContext.perform { [unowned self] in
                    cell.run(mode: .analyz, text: "_mood".localized(), user: self.currentUser)
                }
                return cell
            }
        case .charts:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsStaticCell.identifier, for: indexPath) as? ChartsStaticCell {
                mainContext.perform { [unowned self] in
                    cell.run(mode: .analyz, text: "_charts".localized(), user: self.currentUser)
                }
                return cell
            }
        case .achievments:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievmentsStaticCell.identifier, for: indexPath) as? AchievmentsStaticCell {
                mainContext.perform { [unowned self] in
                    cell.run(mode: .analyz, text: "_achievments".localized(), user: self.currentUser)
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let item = items[indexPath.row]
         switch item.type {
         case .mood:
             return CGSize(width: UIScreen.main.bounds.width - 30, height: 130)
         case .charts:
             return CGSize(width: UIScreen.main.bounds.width - 30, height: 180)
         case .achievments:
             return CGSize(width: UIScreen.main.bounds.width - 30, height: 410)
         }
     }

     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 28, left: 15, bottom: 28, right: 15)
     }

     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 10
     }

     func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 33
     }
}
