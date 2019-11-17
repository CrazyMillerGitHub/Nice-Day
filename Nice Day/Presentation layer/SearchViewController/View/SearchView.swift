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
    
    var viewModel = SearchViewModel()
    
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
   
    // MARK: SearchBar config
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search"
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = .searchBarColor
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //config UI
        prepareUI()
        self.searchBar.delegate = viewModel
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
        let searchViewController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { assert(false, "Something went wrong with cell config") }
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
