//
//  ProfileView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileView: UIViewController {

    var viewModel = ProfileViewModel()
    
    let navigationBar: UINavigationBar = {
        let navigationBar: UINavigationBar = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Profile")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.bgColor.withAlphaComponent(0.2)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(getClose))
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()
    
    // MARK: topView
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgColor
        return view
    }()
    
    weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        collectionView.addSubview(topView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            // bottomView constraints
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
        
        collectionView.backgroundColor = .secondGradientColor
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .bgColor
        setupView()
        setupConstraint()
        collectionView.register(AboutCell.self, forCellWithReuseIdentifier: AboutCell.identifier)
        collectionView.register(ProfileAchievmentsCell.self, forCellWithReuseIdentifier: ProfileAchievmentsCell.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
    }
    
    // MARK: Настройка constraint
    private func setupConstraint() {
        NSLayoutConstraint.activate([
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
            
    }
    
    private func setupView() {
        self.view.addSubview(navigationBar)
    }
    
    @objc
    private func getClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
