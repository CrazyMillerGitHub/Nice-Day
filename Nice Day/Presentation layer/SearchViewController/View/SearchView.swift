//
//  SearchView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import DeckTransition

// MARK: - SearchView
final class SearchView: UIViewController {

    // MARK: Presenter
    private var presenter: SearchViewPresenter!

    // MARK: - prepare properties
    private lazy var tableView = UITableView().with { tableView in
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }

    private let searchViewController = UISearchController().with { searchViewController in
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.searchBar.setScopeBarButtonBackgroundImage(UIImage(), for: .focused)
        searchViewController.searchBar.scopeButtonTitles = ["Effective", "Favourite", "Popular"]
        searchViewController.searchBar.showsScopeBar = true
    }

    // MARK: - view cycle
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // config UI
        prepareUI()
        presenter = SearchViewPresenter(tableView: tableView, delegate: self)
        searchViewController.searchResultsUpdater = self
        searchViewController.searchBar.delegate = self
    }

    // MARK: prepare UI
    private func prepareUI() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.topItem?.title = "_search".localized()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.searchController = searchViewController
        definesPresentationContext = true
    }
}

// MARK: - searchUpdating
extension SearchView: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        presenter.items = filteredItems(for: searchController.searchBar.text)
        presenter.applySnapshot()
    }

    func filteredItems(for queryOrNil: String?) -> [ActivityElement] {
        let items = ActivityElement.elements
        guard let query = queryOrNil, !query.isEmpty else {
            return items
        }
        return items.filter { item in
            return item.name.lowercased().contains(query.lowercased())
        }
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 1 {
            let items = ActivityElement.elements
            presenter.items = items.filter { item in
                return item.category == .active
            }
            presenter.applySnapshot()
        }
    }

}
