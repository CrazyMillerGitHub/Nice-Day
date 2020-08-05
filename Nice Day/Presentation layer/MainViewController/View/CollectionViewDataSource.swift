//
//  MainViewPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 14.05.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

final class MainViewDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MainItem>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, MainItem>
    // define properties
    private var collectionView: UICollectionView!
    
    private weak var delegate: UIViewController!

    var items: [MainItem] = [] {
        didSet {
            if oldValue.isEmpty {
                update(with: items, animate: true)
            }
        }
    }

    private lazy var dataSource = makeDataSource()

    // private enum for diffable data source
    private enum Section: String, CaseIterable {
        case main
    }

    init(items: [MainItem] = [],
         collectionView: UICollectionView,
         delegate: UIViewController) {
        self.collectionView = collectionView
        self.delegate = delegate
        self.items = items
        super.init()
        setup()
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
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert(notification:)), name: .showAlert, object: nil)
        // perform collectionView
        collectionView.delegate = self
        collectionView.frame = delegate.view.frame
        // register cells
        collectionView.register(BonusCell.self, forCellWithReuseIdentifier: BonusCell.identifier)
        collectionView.register(ChartsCell.self, forCellWithReuseIdentifier: ChartsCell.identifier)
        collectionView.register(FriendsCell.self, forCellWithReuseIdentifier: FriendsCell.identifier)
        collectionView.register(MoodCell.self, forCellWithReuseIdentifier: MoodCell.identifier)
        collectionView.register(SpecialCell.self, forCellWithReuseIdentifier: SpecialCell.identifier)
        collectionView.register(AchievmentsCell.self, forCellWithReuseIdentifier: AchievmentsCell.identifier)
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

    @objc func removeCell() {
        if let idx = items.firstIndex(where: {$0.type == .mood }),
            let item = dataSource.itemIdentifier(for: IndexPath(item: idx, section: 0)) {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.deleteItems([item])
            items.remove(at: idx)
            dataSource.apply(currentSnapshot)
        }
    }

    func addMoodCell() {
        if let idx = items.firstIndex(where: {$0.type == .mood }),
            let item = dataSource.itemIdentifier(for: IndexPath(item: idx, section: 0)) {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.insertItems([MainItem(type: .mood)], afterItem: item)
            items.insert(MainItem(type: .mood), at: 1)
            dataSource.apply(currentSnapshot)
        }
    }

    @objc func showAlert(notification: NSNotification) {
        guard let data = notification.object as? [String], let body = data.first else {
            return
        }
        delegate.showAlert(service: AlertService(), title: "Alert!", body: body, button: "Ok")

    }
    
}

extension UIViewController {
    func showAlert(service: AlertService,
                   title: String,
                   body: String,
                   button: String) {
        
        let alertService = service

        present(alertService.alert(title: title, body: body, button: button), animated: true, completion: nil)
    }
}
