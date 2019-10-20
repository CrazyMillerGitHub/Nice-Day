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
    //  создание imageView
    let imageView: UIImageView = {
           let imageView = UIImageView()
        imageView.layer.cornerRadius = 45.5
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.clipsToBounds = true
           imageView.contentMode = .scaleAspectFit
           imageView.backgroundColor = .red
           return imageView
       }()
    
    let navigationBar: UINavigationBar = {
        let navigationBar: UINavigationBar = UINavigationBar()
        let navigationItem = UINavigationItem(title: "Profile")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .bgColor
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(getClose))
        navigationItem.leftBarButtonItem = doneBtn
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()
    
    // MARK: SignOut Button
    let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .sunriseColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("_signOut".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
    weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
               collectionView.translatesAutoresizingMaskIntoConstraints = false
               self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 56),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        collectionView.backgroundColor = .white
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
        imageView.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 60),
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageView.widthAnchor.constraint(equalToConstant: 91.0),
        imageView.heightAnchor.constraint(equalToConstant: 91.0),
        
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
        //SignOutButtonConstraints
        signOutButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
        signOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        signOutButton.heightAnchor.constraint(equalToConstant: 46),
        signOutButton.widthAnchor.constraint(equalToConstant: 143)
        ])
            
    }
    
    private func setupView() {
        setupNavigationBar()
        setupImageView()
        self.view.addSubview(signOutButton)
    }
    
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
    }
    
    @ objc private func getClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupImageView() {
        self.view.addSubview(imageView)
    }

}
