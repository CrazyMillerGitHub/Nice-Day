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
    private enum Constants {

        case buttonRadius
        case buttonHeight

        var value: CGFloat {
            switch self {
            case .buttonHeight:
                return 46.0
            case .buttonRadius:
                return 15.0
            }
        }
    }

    static var identifier: String = String(describing: type(of: self))

    // MARK: ViewModel
    private let viewModel: AchievmentViewModel!

    private var blurEffectView = UIVisualEffectView().with { blurEffectView in
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private var vibrancyView = UIVisualEffectView().with { blurEffectView in
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private var unavailableLaebl = UILabel().with { label in
        label.text = "_later".localized
        label.font = UIFont().roundedFont(ofSize: .headline, weight: .semibold)
        label.textAlignment = .center
        label.textColor = UIColor.systemBackground
    }
    
    // MARK: - UI init
    private lazy var showMoreButton = UIButton().with { button in
        button.backgroundColor = .secondGradientColor
        button.layer.cornerRadius = Constants.buttonRadius.value
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
        contentView.addSubview(achievmentCollectionView)
        contentView.addSubview(showMoreButton)
        achievmentCollectionView.delegate = viewModel
        achievmentCollectionView.dataSource = viewModel
        showMoreButton.addTarget(self, action: #selector(showMoreAction), for: .touchUpInside)
        prepareConstraint()
        
        blurEffectView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width,
                                      height: contentView.frame.height - Constants.buttonHeight.value)
        unavailableLaebl.frame = blurEffectView.frame
        blurEffectView.effect = getBlurEffect()
        vibrancyView.frame = contentView.frame
        vibrancyView.effect = getVibrancyEffect()
        vibrancyView.contentView.addSubview(unavailableLaebl)
        blurEffectView.contentView.addSubview(vibrancyView)

        contentView.addSubview(blurEffectView)
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

    private func getBlurEffect() -> UIBlurEffect {

        return UIBlurEffect(style: traitCollection.userInterfaceStyle == .light ? .regular : .dark)
    }

    private func getVibrancyEffect() -> UIVibrancyEffect {
        UIVibrancyEffect(blurEffect: getBlurEffect())
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        vibrancyView.effect = getVibrancyEffect()
        blurEffectView.effect = getBlurEffect()
    }

    // MARK: - prepare constraints
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            // showMoreButton constraints
            showMoreButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            showMoreButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight.value),
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
