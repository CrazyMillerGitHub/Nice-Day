//
//  FriendsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class NewFriendAdditionalLabel: UILabel {
    
    enum LabelType {
        case lvl
        case match
    }
    
    init(ofString:String, type:LabelType) {
        super.init(frame: .zero)
        let attributedString = NSMutableAttributedString(string: " \(ofString) \(type == .lvl ? "Lvl" : "_match".localized())  ", attributes: [
          .font: UIFont.systemFont(ofSize: 11.0, weight: .bold),
          .foregroundColor: UIColor.inverseColor,
          .kern: 0.18
        ])
        attributedString.addAttribute(.foregroundColor, value: type == .lvl ? UIColor.green : UIColor.sunriseColor, range: NSRange(location: 1, length: ofString.count + 1))
        attributedText = attributedString
        layer.backgroundColor = UIColor.bgColor.cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.03
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.borderColor = UIColor.bgColor.withAlphaComponent(0.02).cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FriendsCell: CoreCell {
    
    static var identifier: String = "friends"
    
    // MARK: newFriendImage init
    private var newFriendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "emoji3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var inviteButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.sunriseColor.cgColor
        button.setTitle("_invite".localized(), for: .normal)
        button.titleLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "400 ft"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor.inverseColor.withAlphaComponent(0.2)
        label.contentMode = .left
        let location = UIImageView()
        location.image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 7))
        location.contentMode = .scaleAspectFit
        location.tintColor = .inverseColor
        stackView.addArrangedSubview(location)
        stackView.addArrangedSubview(label)
        return stackView
    }()
    
    private var levelLabel = NewFriendAdditionalLabel(ofString: "10",type: .lvl)
    
    private var matchLabel = NewFriendAdditionalLabel(ofString: "50%",type: .match)
    
    // MARK: newFriendTitleLabel init
    private var newFriendTitleLabel = NewFriendTitleLabel(of: "Fred Perry")
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? FriendsCellModelItem else { return }
            cellTitleLabel.text = item.titleText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: prepareUI (настройка UI)
       func prepareUI() {
           refresh()
       }
       
    func refresh() {
        addSubview(newFriendImage)
        addSubview(newFriendTitleLabel)
        addSubview(locationStackView)
        addSubview(inviteButton)
        addSubview(levelLabel)
        addSubview(matchLabel)
        NSLayoutConstraint.activate([
            // newFriendImage Constraint
            newFriendImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            newFriendImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newFriendImage.heightAnchor.constraint(equalToConstant: 48),
            newFriendImage.widthAnchor.constraint(equalToConstant: 48),
            
            newFriendTitleLabel.topAnchor.constraint(equalTo: newFriendImage.topAnchor),
            newFriendTitleLabel.leadingAnchor.constraint(equalTo: newFriendImage.trailingAnchor, constant: 13),
            
            locationStackView.centerYAnchor.constraint(equalTo: newFriendTitleLabel.centerYAnchor, constant: 1),
            locationStackView.leadingAnchor.constraint(equalTo: newFriendTitleLabel.trailingAnchor, constant: 3),
            
            inviteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            inviteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            inviteButton.heightAnchor.constraint(equalToConstant: 46),
            inviteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: newFriendTitleLabel.bottomAnchor, constant: 7),
            levelLabel.leadingAnchor.constraint(equalTo: newFriendTitleLabel.leadingAnchor),
            levelLabel.heightAnchor.constraint(equalToConstant: 20),
            
            matchLabel.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor,constant: 10),
            matchLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            matchLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
       
}
