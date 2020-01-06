//
//  SearchView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import DeckTransition

class SearchView: UIViewController {
    
    // TableView
    weak var tableView: UITableView!
    
    // ViewModel
    private var viewModel = SearchViewModel()
    
    // Model
    private var model = SearchModel()
    
    // Filtered Model
    private var filteredModel = [SearchElement]()
    
    // MARK: searchController
    private let searchViewController: UISearchController = {
        let searchViewController = UISearchController(searchResultsController: nil)
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.searchBar.setScopeBarButtonBackgroundImage(UIImage(), for: .focused)
        searchViewController.searchBar.scopeButtonTitles = ["Effective", "Favourite", "Popular"]
        searchViewController.searchBar.showsScopeBar = true
        return searchViewController
    }()
    
    // MARK: SearchBarIsEmpty
    private var searchBarIsEmpty: Bool {
        guard let text = searchViewController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    // MARK: IsFiltering
    private var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchViewController.searchBar.selectedScopeButtonIndex != 0
        return searchViewController.isActive && (!searchBarIsEmpty || searchBarScopeIsFiltering)
    }
    
//    private var segmentedControl: CustomSegmentedControl {
//        let segmentedControl = CustomSegmentedControl(items: ["Favourite","Effective", "Popular"])
//        segmentedControl.addTarget(self, action: #selector(segmentedControlButtonClickAction(_:)), for: .valueChanged)
//        segmentedControl.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: 31)
//        return segmentedControl
//    }
    
    override func loadView() {
        super.loadView()
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        self.tableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //config UI
        prepareUI()
        searchViewController.searchBar.delegate = self
        searchViewController.searchResultsUpdater = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
    }
    
    private func prepareUI() {
        self.view.backgroundColor = .bgColor
        self.tableView.backgroundColor = .bgColor
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = "_search".localized()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension SearchView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFiltering ? filteredModel.count : model.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UITableViewCell() }
        cell.textTitle.text = isFiltering ? filteredModel[indexPath.row].name : model.array[indexPath.row].name
        cell.dscrTitle.setAttributedStringForSearch(for: isFiltering ? filteredModel[indexPath.row].xpCount : model.array[indexPath.row].xpCount)
        cell.setStatusGrade(isFiltering ? filteredModel[indexPath.row].category : model.array[indexPath.row].category)
        cell.prepareCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 31
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            
            let modal = ActivityView()
            let transitionDelegate = DeckTransitioningDelegate(isSwipeToDismissEnabled: false)
            modal.transitioningDelegate = transitionDelegate
            modal.modalPresentationStyle = .custom
            self.present(modal, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}

private extension SearchView {
    
    @objc
    func segmentedControlButtonClickAction(_ sender: UISegmentedControl) {
      
    }
    
}

extension SearchView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else { return }
        
        fileterContentForSearchController(searchText: searchController.searchBar.text ?? "", scope: scope)
    }
    
    func fileterContentForSearchController(searchText: String, scope: String = "Effective") {
        filteredModel = model.array.filter { (element: SearchElement) -> Bool in
            
            //let doesCategoryMatch = (scope == "Favourite")
            
            return element.name.lowercased().contains(searchText.lowercased())
        }
        
        if scope == "Effective" {
            filteredModel.sort { $0.name < $1.name }
        }
        
        tableView.reloadData()
    }
    
}

extension SearchView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scopeButtonTitles = searchBar.scopeButtonTitles?[selectedScope] else { return }
        fileterContentForSearchController(searchText: searchBar.text ?? "", scope: scopeButtonTitles)
    }
    
}
