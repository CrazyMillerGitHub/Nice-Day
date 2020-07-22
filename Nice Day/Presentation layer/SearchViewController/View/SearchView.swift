//
//  SearchView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import DeckTransition

protocol SeacrhControllerCallable: UIViewController {

    func showActivity(element: ActivityElement)
}

// MARK: - SearchView
final class SearchView: UIViewController, SeacrhControllerCallable {

    enum SortState: Int {

        case effective, popular, favourite
    }

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
        searchViewController.searchBar.scopeButtonTitles = ["_effective".localized,
                                                            "_popular".localized,
                                                            "_favourite".localized]
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
        presenter = SearchViewPresenter(activityService: ActivtityService(),
                                        tableView: tableView,
                                        delegate: self)
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

    func showActivity(element: ActivityElement) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {

            let activityView = ActivityView(element: element)

            let transitionDelegate = DeckTransitioningDelegate()
            activityView.transitioningDelegate = transitionDelegate
            activityView.modalPresentationStyle = .custom

            self.present(activityView, animated: true, completion: nil)
        }
    }
}

// MARK: - searchUpdating
extension SearchView: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        presenter.items = filteredItems(for: searchController.searchBar.text)
        presenter.applySnapshot()
    }

    func filteredItems(for queryOrNil: String?) -> [ActivityElement] {

        let items = presenter.searchItems

        guard let query = queryOrNil, !query.isEmpty else {
            return items
        }

        let filteredActvity = items.filter { item in
            return item.userLang.lowercased().contains(query.lowercased())
        }

        if !filteredActvity.isEmpty {

            return filteredActvity
        } else {

            return items.filter { item in
                let activityName = item.userLang == item.ruLang ? item.enLang : item.ruLang
                return activityName.lowercased().contains(query.lowercased())
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        guard let state = SortState(rawValue: selectedScope) else { return }

        switch state {
        case .popular:
            presenter.searchItems.sort { $0.popularity > $1.popularity }
            presenter.applySnapshot(animate: false)
        case .effective:
            presenter.searchItems.sort { $0.activityCost > $1.activityCost }
            presenter.applySnapshot(animate: false)
        case .favourite:
            ActivtityService.fetchFavouriteActvities(filter: [""]) { result in
                switch result {
                case .success(let favourites):
                    DispatchQueue.global(qos: .utility).async {
                        let dispatchGroup = DispatchGroup()

                        var arr = [ActivityElement]()

                        for item in self.presenter.searchItems {
                            dispatchGroup.enter()
                            if favourites.contains(item.documentID) { arr.append(item) }
                            dispatchGroup.leave()
                        }

                        dispatchGroup.notify(queue: .main) {
                            self.presenter.items = arr
                            self.presenter.applySnapshot(animate: true)

                        }
                    }
                case .failure(let err):
                    print(err.localizedDescription ?? "")
                }
            }
        }
    }

}
