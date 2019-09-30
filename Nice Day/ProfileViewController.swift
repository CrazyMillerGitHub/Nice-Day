//
//  ProfileViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

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
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: nil, action: #selector(getClose))
        navigationItem.leftBarButtonItem = doneBtn
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.delegate = self
        setupView()
        setupConstraint()
        
    }
    
    // Настройка constraint
    private func setupConstraint() {
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 60),
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageView.widthAnchor.constraint(equalToConstant: 91.0),
        imageView.heightAnchor.constraint(equalToConstant: 91.0),
        
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
            
    }
    
    private func setupView() {
        bgView()
        setupNavigationBar()
        setupImageView()
    }
    
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
    }
    
    @ objc private func getClose() {
        
    }
    // настройка цвета bg
    private func bgView() {
        self.view.backgroundColor = .black
        let bgView = UIView(frame: self.view.frame)
        bgView.backgroundColor = .bgColor
        bgView.layer.cornerRadius = 5
        self.view.addSubview(bgView)
    }
    
    private func setupImageView() {
        self.view.addSubview(imageView)
    }

}
