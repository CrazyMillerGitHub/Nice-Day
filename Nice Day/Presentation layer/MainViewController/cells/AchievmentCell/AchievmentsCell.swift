//
//  AchievmentsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class AchievmentsCell: CoreCell {

    // MARK: nested constants
    private enum Constants: CGFloat {
        case buttonRadius = 15.0
        case buttonHeight = 46.0
    }

    static var identifier: String = String(describing: type(of: self))

    // MARK: ViewModel
    private let viewModel: AchievmentViewModel!
    
    // MARK: - UI init
    private lazy var showMoreButton = UIButton().with { button in
        button.backgroundColor = .secondGradientColor
        button.layer.cornerRadius = Constants.buttonRadius.rawValue
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.setTitle("_showMore".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
    }

    private lazy var achievmentCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(AchievmentCell.self, forCellWithReuseIdentifier: AchievmentCell.achievmentIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        self.viewModel = AchievmentViewModel()
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(achievmentCollectionView)
        addSubview(showMoreButton)
        achievmentCollectionView.delegate = viewModel
        achievmentCollectionView.dataSource = viewModel
        showMoreButton.addTarget(self, action: #selector(showMoreAction), for: .touchUpInside)
        prepareConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupViews()
    }

    @objc private func showMoreAction() {
        NotificationCenter.default.post(name: .showAwards, object: nil)
    }

    // MARK: - prepare constraints
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            // showMoreButton constraints
            showMoreButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            showMoreButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight.rawValue),
            showMoreButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            showMoreButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            // friendsCollectionView
            achievmentCollectionView.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor),
            achievmentCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            achievmentCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            achievmentCollectionView.bottomAnchor.constraint(equalTo: showMoreButton.topAnchor)
        ])
    }
    
}
