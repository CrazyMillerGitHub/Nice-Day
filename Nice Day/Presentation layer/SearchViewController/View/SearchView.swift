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
    
    //init
    weak var tableView: UITableView!
    
    private var viewModel = SearchViewModel()
    
    private var model = SearchModel()
    
    private var filteredModel = [String]()
    
    // MARK: searchController
    private let searchViewController: UISearchController = {
        let searchViewController = UISearchController(searchResultsController: nil)
        searchViewController.obscuresBackgroundDuringPresentation = false
        return searchViewController
    }()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchViewController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchViewController.isActive && !searchBarIsEmpty
    }
    
    override func loadView() {
        super.loadView()
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        
        self.tableView = tableView
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //config UI
        prepareUI()
        searchViewController.searchResultsUpdater = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        // Do any additional setup after loading the view.
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
        cell.textTitle.text = isFiltering ? filteredModel[indexPath.row] : model.array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .bgColor
        let segmentedControl = CustomSegmentedControl(items: ["Favourite","Effective", "Popular"])
        
        segmentedControl.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: 31)
        view.addSubview(segmentedControl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 31
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            
            let modal = ActivityView()
            let transitionDelegate = DeckTransitioningDelegate()
            modal.transitioningDelegate = transitionDelegate
            modal.modalPresentationStyle = .custom
            self.present(modal, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}
extension SearchView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        fileterContentForSearchController(text: searchController.searchBar.text ?? "")
    }
    
    func fileterContentForSearchController(text: String) {
        filteredModel = model.array.filter { (val: String) -> Bool in
            return val.lowercased().contains(text.lowercased())
        }
        tableView.reloadData()
    }
    
}
