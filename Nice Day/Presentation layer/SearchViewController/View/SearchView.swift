//
//  SearchView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

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
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.tableView = tableView
        
        self.view.addSubview(searchBar)
        
        self.view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
        searchBar.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant:  30),
        searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 33),
        searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -33),
        searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    // MARK: NavigationVar config
     let navigationBar: UINavigationBar = {
           let navigationBar: UINavigationBar = UINavigationBar()
           let navigationItem = UINavigationItem(title: "Search")
           navigationBar.shadowImage = UIImage()
           navigationBar.isTranslucent = false
           navigationBar.backgroundColor = .bgColor
           navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
           navigationBar.translatesAutoresizingMaskIntoConstraints = false
           navigationBar.setItems([navigationItem], animated: false)
           return navigationBar
       }()
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}
