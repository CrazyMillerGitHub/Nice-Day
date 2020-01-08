//
//  ActivityView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 11.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CHIPageControl

class ActivityView: UIViewController {
    
    var viewModel = ActivityViewModel()
    
    // MARK: collectionView
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(ActivityViewCell.self, forCellWithReuseIdentifier: ActivityViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: Создание bgView
    private func performView() {
        self.view.backgroundColor = UIColor.bgColor.withAlphaComponent(0.5)
        let blurEffect = UIBlurEffect(style: isDarkModeActivated() ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    // MARK: headerView
    fileprivate var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .projectGreyColor
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: pageControl
    fileprivate var pageControl : CHIPageControlAleppo = {
        let pageControl = CHIPageControlAleppo()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.radius = 4
        pageControl.tintColor = .gray
        pageControl.currentPageTintColor = .inverseColor
        pageControl.padding = 10
        return pageControl
    }()
    
    // MARK: PrepareUI
    // Подготовка UI к работе
    private func prepareUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
    }
    
    /// Preparing constraints
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            //HeaderView constraint
            self.headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 13),
            self.headerView.widthAnchor.constraint(equalToConstant: 32),
            self.headerView.heightAnchor.constraint(equalToConstant: 5),
            //pageControl constraint
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24),
            self.pageControl.widthAnchor.constraint(equalToConstant: 89.0 ),
            self.pageControl.heightAnchor.constraint(equalToConstant: 10.0),
            //collectionView constraint
            self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor, constant: -5)
        ])
    }
    
    override func loadView() {
        super.loadView()
        self.performView()
        self.prepareUI()
        self.prepareConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }
    
    private func isDarkModeActivated() -> Bool {
        if self.traitCollection.userInterfaceStyle == .dark {
            return true
        }
        return false
    }
    
}

extension ActivityView: PageControlProtocol {
    func progress(_ progress: Double) {
        pageControl.progress = progress
        
    }
}
