//
//  SearchCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol Builder {}

extension Builder {
    func with(config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}

extension NSObject: Builder {}

public enum Grade {

    case active, passive
}

// MARK: - SearchCell
final class SearchCell: UITableViewCell {

    // MARK: setting constraints
    private enum Constants: CGFloat {
        
        case vSpacing = 10.0
        case hSpacing = 5.0
        case gradeSize = 16.0
        case multiplier = 0.8
        case leadingConstraint = 18
    }
    
    static var identifier: String = String(describing: type(of: self))

    // MARK: - perofrm properties
    private lazy var activityLabel = UILabel().with { label in
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .inverseColor
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var descriptionLabel = UILabel().with { label in
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var mainStackView = UIStackView().with { stackView in
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = Constants.vSpacing.rawValue
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var gradeImageView = UIImageView().with { imageView in
        imageView.contentMode = .scaleToFill
        (imageView.frame.size.height, imageView.frame.size.width) = (Constants.gradeSize.rawValue, Constants.gradeSize.rawValue)
    }

    private lazy var HStackView = UIStackView().with { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = Constants.hSpacing.rawValue
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator
        // add SubViews for Main and H Stack
        HStackView.addArrangedSubview(gradeImageView)
        HStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(activityLabel)
        mainStackView.addArrangedSubview(HStackView)
        // add subview
        addSubview(mainStackView)
        // perform constrants
        prepareConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - perform constraints
    private func prepareConstraints() {
        NSLayoutConstraint.activate([
            // stackView constraints
            mainStackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: Constants.multiplier.rawValue),
            mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingConstraint.rawValue)
        ])
    }

    // MARK: - configure Cell
    func configureCell(model: ActivityElement) {

        activityLabel.text = model.userLang
        descriptionLabel.setAttributedStringForSearch(for: model.activityCost)
        gradeImageView.image = UIImage(named: model.activityType == "a" ? "activeGrade" : "passiveGrade")
    }

}
