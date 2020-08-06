//
//  FriendsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol LabelConfigurable: class {
    func present()
}

final class FriendLabel: UILabel, LabelConfigurable {

    init(_ attributedString: NSAttributedString = NSAttributedString()) {
        super.init(frame: .zero)
        present()
    }

    func present() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.bgColor.cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.03
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.borderColor = UIColor.bgColor.withAlphaComponent(0.02).cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UILabel {

//    static var friendStatsLabel = UILabel().with { label in
//
//        // customize label
//        label.layer.backgroundColor = UIColor.bgColor.cgColor
//        label.layer.cornerRadius = 8
//        label.layer.borderWidth = 1
//        label.layer.shadowRadius = 4
//        label.layer.shadowOpacity = 0.03
//        label.layer.shadowOffset = CGSize(width: 0, height: 2)
//        label.layer.borderColor = UIColor.bgColor.withAlphaComponent(0.02).cgColor
//    }

    static var friendLabel = UILabel().with { label in
        label.contentMode = .left
        label.tintColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UserModel
struct UserModel {

    internal enum Style: String {
        case lvl
        case match
    }
    // MARK: property init
    internal let firstName: String
    internal let lastName: String
    private let match: CGFloat
    private let level: Int

    // MARK: initializer
    init (_ firstName : String = "Lewis", _ lastName: String = "Webb", _ match: CGFloat = 50, _ level: Int = 1) {
        self.firstName = firstName
        self.lastName = lastName
        self.match =  match
        self.level = level
    }

    internal func attributedString(for type: Style) -> NSMutableAttributedString {
        let value = type == .lvl ? String(level) : match.description
        let str = " \(value) \(type == .lvl ? "Lvl" : "Match")"
        let attributedString = NSMutableAttributedString(string: str, attributes: [
            .font: UIFont.systemFont(ofSize: 11.0, weight: .bold),
            .foregroundColor: UIColor.inverseColor,
            .kern: 0.18
        ])
        attributedString.addAttribute(.foregroundColor, value: type == .lvl ? UIColor.green : UIColor.sunriseColor, range: NSRange(location: 1, length: value.count + 1))

        return attributedString
    }
}
// MARK: - FriendsCell
final class FriendsCell: CoreCell {

    // MARK: define identifier
    static var identifier: String = String(describing: type(of: self))

    // MARK: - prepare properties
    private var levelLabel = FriendLabel()

    private var matchLabel = FriendLabel()

    private var friendLabel: UILabel = .friendLabel

    // MARK: - setup UI
    private lazy var inviteButton = UIButton().with { button in
        button.layer.backgroundColor = UIColor.sunriseColor.cgColor
        button.setTitle("_invite".localized(), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var profileImage = UIImageView().with { imageView in
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "emoji3")
        imageView.contentMode = .scaleAspectFill
    }

    private lazy var locationStackView = UIStackView().with { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Refactor
        let label = UILabel()
        label.text = "400 ft"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor.inverseColor.withAlphaComponent(0.2)
        label.contentMode = .left
        let location = UIImageView()
        location.image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 7))
        location.contentMode = .scaleAspectFit
        location.tintColor = .inverseColor
        // TODO: End Refactor
        stackView.addArrangedSubview(location)
        stackView.addArrangedSubview(label)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: prepareUI (настройка UI)
       func prepareUI() {
           refresh()
       }
       
    fileprivate func extractedFunc() -> [NSLayoutConstraint] {
        return [
            // newFriendImage Constraint
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 48),
            profileImage.widthAnchor.constraint(equalToConstant: 48),
            
            friendLabel.topAnchor.constraint(equalTo: profileImage.topAnchor),
            friendLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 13),
            
            locationStackView.centerYAnchor.constraint(equalTo: friendLabel.centerYAnchor, constant: 1),
            locationStackView.leadingAnchor.constraint(equalTo: friendLabel.trailingAnchor, constant: 3),
            
            inviteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            inviteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            inviteButton.heightAnchor.constraint(equalToConstant: 46),
            inviteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: friendLabel.bottomAnchor, constant: 7),
            levelLabel.leadingAnchor.constraint(equalTo: friendLabel.leadingAnchor),
            levelLabel.heightAnchor.constraint(equalToConstant: 20),
            
            matchLabel.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor,constant: 10),
            matchLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            matchLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
    }
    
    private func refresh() {
        addSubview(profileImage)
        addSubview(friendLabel)
        addSubview(locationStackView)
        addSubview(inviteButton)
        addSubview(levelLabel)
        addSubview(matchLabel)
        NSLayoutConstraint.activate(extractedFunc())
    }

    internal func configure() {
        let model = UserModel()
        levelLabel.attributedText = model.attributedString(for: .lvl)
        matchLabel.attributedText = model.attributedString(for: .match)
        friendLabel.text = model.firstName + " " + model.lastName
    }
}
