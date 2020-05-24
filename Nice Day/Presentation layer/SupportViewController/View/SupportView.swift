//
//  SupportViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 21.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SupportView: UIViewController {
    
    weak var tableView: UITableView!
    var items = SupportViewModel()
    
    override func loadView() {
        super.loadView()
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        self.tableView = tableView
        
    }
    let navigationBar: UINavigationBar = {
        let navigationBar: UINavigationBar = UINavigationBar()
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.bgColor
         let navigationItem = UINavigationItem(title: "")
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAction))
        navigationBar.setItems([navigationItem], animated: true)
        return navigationBar
    }()
    let forgotPassswordLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Forgot\nPassword?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .inverseColor
        return label
    }()
    
    let dontWorryLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t worry"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .sunriseColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        tableView.delegate = items
        tableView.dataSource = items
        tableView.register(EmailSupportCell.self, forCellReuseIdentifier: EmailSupportCell.identifier)
        tableView.register(FiveDigitCell.self, forCellReuseIdentifier: FiveDigitCell.identifier)
        tableView.register(NewPasswordCell.self, forCellReuseIdentifier: NewPasswordCell.identifier)
        tableView.register(NewPasswordAgain.self, forCellReuseIdentifier: NewPasswordAgain.identifier)
        
             NSLayoutConstraint.activate([
            
            navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 56.0),
            
            forgotPassswordLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 33),
            forgotPassswordLabel.widthAnchor.constraint(equalToConstant: 183),
            forgotPassswordLabel.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 30),
            
            dontWorryLabel.leadingAnchor.constraint(equalTo: self.forgotPassswordLabel.leadingAnchor, constant: 0),
            dontWorryLabel.topAnchor.constraint(equalTo: self.forgotPassswordLabel.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: self.dontWorryLabel.bottomAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        check()
    }
    
    @objc
    private func dismissAction(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func check() {
        for _ in 0...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.tableView.beginUpdates()
                let email = FiveDigitKeyModelItem()
                self.items.items.append(email)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    private func prepareUI() {
        self.view.addSubview(dontWorryLabel)
        self.view.addSubview(forgotPassswordLabel)
        self.view.addSubview(navigationBar)
        self.view.backgroundColor = .bgColor
    }
}
