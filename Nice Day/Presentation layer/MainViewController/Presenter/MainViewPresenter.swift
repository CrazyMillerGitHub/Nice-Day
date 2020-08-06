//
//  MainViewPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 17.05.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol MainViewCallable: UIViewController { }

final class MainViewPresenter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - prepare properties and dataSource
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MainItem>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, MainItem>

    private var items: [MainItem] = {
        [MainItem(type: .bonus),
         MainItem(type: .charts),
         MainItem(type: .achievments),
         MainItem(type: .special)]
    }()

    private lazy var dataSource = makeDataSource()

    private var collectionView: UICollectionView

    private weak var delegate: MainViewCallable?

    // private enum for diffable data source
    private enum Section: String, CaseIterable {
        case main
    }

    init(collectionView: UICollectionView, delegate: MainViewCallable) {
        self.delegate = delegate
        self.collectionView = collectionView
        super.init()
        DispatchQueue.main.async { [unowned self] in
            self.setup()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { (collectionView, indexPath, mainItem) -> UICollectionViewCell? in
            switch mainItem.type {
            case .bonus:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BonusCell.identifier, for: indexPath) as? BonusCell else { break }
                return cell
            case .charts:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartsCell.identifier, for: indexPath) as? ChartsCell else { break }
                cell.cellTitleLabel.text = "_charts".localized
                return cell
            case .achievments:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievmentsCell.identifier, for: indexPath) as? AchievmentsCell else { break }
                cell.cellTitleLabel.text = "_achievments".localized
                return cell
            case .friend:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell else { break }
                cell.cellTitleLabel.text = "_friends".localized
                return cell
            case .special:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialCell.identifier, for: indexPath) as? SpecialCell else { break }
                cell.cellTitleLabel.text = "_special".localized
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodCell.identifier, for: indexPath) as? MoodCell else { break }
                cell.cellTitleLabel.text = "_mood".localized
                return cell
            }
            return UICollectionViewCell()
        }
    }

    private func setup() {
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(removeCell), name: .removeMoodCell, object: nil)
        // perform collectionView
        collectionView.delegate = self
        collectionView.frame = delegate?.view.frame ?? .zero
//        collectionView.frame = dele
        // register cells
        collectionView.register(BonusCell.self, forCellWithReuseIdentifier: BonusCell.identifier)
        collectionView.register(ChartsCell.self, forCellWithReuseIdentifier: ChartsCell.identifier)
        collectionView.register(FriendsCell.self, forCellWithReuseIdentifier: FriendsCell.identifier)
        collectionView.register(MoodCell.self, forCellWithReuseIdentifier: MoodCell.identifier)
        collectionView.register(SpecialCell.self, forCellWithReuseIdentifier: SpecialCell.identifier)
        collectionView.register(AchievmentsCell.self, forCellWithReuseIdentifier: AchievmentsCell.identifier)
        update(with: items)
        checkMoodAvaibility()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: .moveAndResizeImage, object: nil)
    }

    func update(with list: [MainItem], animate: Bool = true) {

        var snapshot = DataSourceSnapshot()

        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }

    private func checkMoodAvaibility() {

        let backgroundContext = CoreDataManager.shared.context(on: .private)
        backgroundContext.perform {
            let currentUser = CoreDataManager.shared.currentUser(backgroundContext)
            if let date = currentUser.moodTime, Calendar.current.isDateInToday(date) { return }
            DispatchQueue.main.async { [weak self] in
                self?.addMoodCell()
            }
        }
    }

    @objc private func removeCell() {
        if let idx = items.firstIndex(where: {$0.type == .mood }),
            let item = dataSource.itemIdentifier(for: IndexPath(item: idx, section: 0)) {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.deleteItems([item])
            items.remove(at: idx)
            dataSource.apply(currentSnapshot)
        }
    }

    private func addMoodCell() {
        if let idx = items.firstIndex(where: {$0.type == .bonus }),
            let item = dataSource.itemIdentifier(for: IndexPath(item: idx, section: 0)) {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.insertItems([MainItem(type: .mood)], afterItem: item)
            items.insert(MainItem(type: .mood), at: 1)
            dataSource.apply(currentSnapshot)
        }
    }
}

extension MainViewPresenter {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return items[indexPath.row].type.size()
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
