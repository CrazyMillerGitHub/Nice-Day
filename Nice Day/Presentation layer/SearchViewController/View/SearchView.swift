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
        
        self.view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant:  30),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 33),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -33),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            // SegmentedControl constrsints
            segmentedControl.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 5),
            segmentedControl.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -5),
            segmentedControl.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 31)
        ])
    }
    
    // MARK: Кастом сегментед контрол
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Favourite","Effective", "Popular"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .sunriseColor

        segmentedControl.setBackgroundImage(UIImage(), for: .focused, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([
            
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        ], for: .selected)
        segmentedControl.setTitleTextAttributes([
                   
            NSAttributedString.Key.foregroundColor: UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0),
                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)
               ], for: .normal)
        return segmentedControl
    }()
    
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
