//
//  ProfileViewPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 21.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Combine

protocol ProfilePresentable: class {

    func signOut()
    func performPicker()
}

// MARK: - Presenter
final class ProfileViewPresenter: NSObject {

    private let items: [ProfileViewModelItem] = {
        return [AboutCellModelItem(), ProfileAchievmentsModelItem()]
    }()

    private var subscriptions = Set<AnyCancellable>()

    private weak var delegate: ProfilePresentable?

    private var collectionView: UICollectionView!
    
    init(collectionView: UICollectionView, delegate: ProfilePresentable) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        configureDelegation()

    }

    private func configureDelegation() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func registerState(state: AboutCell.SubjectType) {
        switch state {
        case .disconnect:
            delegate?.signOut()
        case .picker:
            delegate?.performPicker()
        }
    }

    private func performSubscription<T: Streamable>(cell: T) {
        cell.outputStream
            .handleEvents(receiveOutput: { [unowned self] state in
                if let state = state as? AboutCell.SubjectType {
                    self.registerState(state: state)
                }
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func loadCurrentUser() -> User {

        let backgroundCotext = CoreDataManager.shared.context(on: .main)

        var user: User!
        backgroundCotext.performAndWait {
            user = CoreDataManager.shared.currentUser(backgroundCotext)
        }
        return user
    }
}

// MARK: - CollectionView
extension ProfileViewPresenter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.section]

        switch item.type {
        case .about:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell else { return UICollectionViewCell() }
            cell.backgroundColor = .white
            cell.currentUser = loadCurrentUser()
            cell.configure()
            performSubscription(cell: cell)
            return cell
        case .achievments:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileDescriptionCell.identifier, for: indexPath) as? ProfileDescriptionCell else { return UICollectionViewCell() }
            cell.layoutIfNeeded()
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = items[indexPath.section]

        switch item.type {
        case .about:
            return CGSize(width: collectionView.bounds.width, height: 431)
        case .achievments:
            return CGSize(width: collectionView.bounds.width, height: 842)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
