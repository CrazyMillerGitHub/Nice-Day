//
//  SearchViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 22.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

// MARK: - SearchViewPresenter
final class SearchViewPresenter: NSObject, UITableViewDelegate {
    
    // MARK: selection enum
    private enum Selection {
        case main
    }
    // MARK: property for items
    internal var items: [ActivityElement]
    // MARK: properties init
    private var tableView: UITableView!
    private weak var delegate: UIViewController!
    // MARK: typealias init
    private typealias DataSource = UITableViewDiffableDataSource<Selection, ActivityElement>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Selection, ActivityElement>
    // MARK: inizialize data source
    private lazy var dataSource = makeDataSource()

    // MARK: - init
    init (items:[ActivityElement] = ActivityElement.elements, tableView: UITableView, delegate: UIViewController) {
        // inizialize properties
        self.tableView = tableView
        self.delegate = delegate
        self.items = items
        super.init()
        configureTableView()
        applySnapshot()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.frame = delegate.view.frame
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UITableViewCell() }
            cell.configureCell(model: model)
            return cell
        }
        return dataSource
    }

    internal func applySnapshot(animate: Bool = true) {

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animate)

    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
        }
    }

     internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}