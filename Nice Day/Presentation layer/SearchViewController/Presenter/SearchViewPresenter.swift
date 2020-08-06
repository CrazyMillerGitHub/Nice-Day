//
//  SearchViewModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 22.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CoreData

// MARK: - SearchViewPresenter
final class SearchViewPresenter: NSObject, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    private enum SearchBarState: Int {

        case effective, popular, favourite

        var sortDescriptor: NSSortDescriptor {
            switch self {

            case .effective, .favourite:
                return NSSortDescriptor(key: "activityCost", ascending: false)
            case .popular:
                return NSSortDescriptor(key: "popularity", ascending: false)
            }
        }

        func createPredicate<T: CVarArg>(info: T) -> NSPredicate {
            var predicates: [NSPredicate] = [NSPredicate]()
            switch self {
            case .favourite:
                predicates.append(NSPredicate(format: "isFavourite == true", info, info))
                fallthrough
            case _:
                predicates.append(NSPredicate(format: "ru CONTAINS[c] %@ OR en CONTAINS[c] %@", info, info))
            }
            return NSCompoundPredicate(type: .and, subpredicates: predicates)
        }

        func defaultPredicate() -> NSPredicate? {
            guard self == .favourite else { return nil }
            return NSPredicate(format: "isFavourite == true")
        }
    }

    private var searchBarStyle: SearchBarState = .effective {
        didSet {
            setupSearchController()
        }
    }

    // MARK: selection enum
    private enum Selection {
        case main
    }

    // MARK: properties init
    private unowned var tableView: UITableView
    private weak var delegate: SeacrhControllerCallable!
    // MARK: typealias init
    private typealias DataSource = UITableViewDiffableDataSource<Selection, Activity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Selection, Activity>
    // MARK: inizialize data source
    private lazy var dataSource = makeDataSource()
    // MARK: ActivityService
    private let activityService: ActivtityService
    // MARK: fetchResultController
    private var fetchedResultsController: NSFetchedResultsController<Activity>!
    private var currentSearchText = ""

    // MARK: - init
    init (activityService: ActivtityService, tableView: UITableView, delegate: SeacrhControllerCallable) {
        // inizialize properties
        self.activityService = activityService
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        configureTableView()
        setupFetchedResultsController()
        setupSearchController()
        update()
    }

    private func update() {
        activityService.fetchActivities { result in
            switch result {
            case .success(let activities):

                for sharedActivity in activities {
                    let activitiy = Activity(context: CoreDataManager.shared.context(on: .main))
                    activitiy.ru = sharedActivity.ruLang
                    activitiy.en = sharedActivity.enLang
                    activitiy.activityCost = Int16(sharedActivity.activityCost)
                    activitiy.popularity = sharedActivity.popularity
                    activitiy.activityType = sharedActivity.activityType
                    activitiy.documentID = sharedActivity.documentID
                }

                CoreDataManager.shared.saveContext()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.fetchBatchSize = 30

        if !currentSearchText.isEmpty {
            request.predicate = searchBarStyle.createPredicate(info: currentSearchText)
        } else {
            if let predicate = searchBarStyle.defaultPredicate() { request.predicate = predicate }
        }

        request.sortDescriptors = [searchBarStyle.sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context(on: .main), sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            applySnapshot()
        } catch {
            print("Fetch failed")
        }
    }

    private func setupSearchController() {
        guard let delegate = delegate else { return }
        delegate.navigationItem.searchController = delegate.searchViewController
        delegate.searchViewController.searchResultsUpdater = self
        delegate.searchViewController.searchBar.delegate = self
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
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource.apply(snapshot, animatingDifferences: animate)

    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        applySnapshot()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.frame = delegate.view.frame
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        delegate.showActivity(element: fetchedResultsController.fetchedObjects![indexPath.row])
    }

    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

}

extension SearchViewPresenter: UISearchResultsUpdating, UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let state = SearchBarState(rawValue: selectedScope) else { return }
        searchBarStyle = state
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        currentSearchText = text
        setupFetchedResultsController()
    }
}
