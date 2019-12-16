//
//  FriendsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class NewFriendAdditionalLabel: UILabel {
    
    enum LabelType {
        case lvl
        case match
    }
    
    init(of:String, type:LabelType) {
        super.init(frame: .zero)
        let attributedString = NSMutableAttributedString(string: " \(of) \(type == .lvl ? "Lvl" : "Match") ", attributes: [
          .font: UIFont.systemFont(ofSize: 11.0, weight: .bold),
          .foregroundColor: UIColor(white: 34.0 / 255.0, alpha: 1.0),
          .kern: 0.18
        ])
        attributedString.addAttribute(.foregroundColor, value: type == .lvl ? UIColor.green : UIColor.sunriseColor, range: NSRange(location: 1, length: of.count + 1))
        attributedText = attributedString
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.03
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.borderColor = UIColor.black.withAlphaComponent(0.02).cgColor
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
        label.textColor = UIColor.black.withAlphaComponent(0.2)
        label.contentMode = .left
        let location = UIImageView()
        location.image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 7))
        location.contentMode = .scaleAspectFit
        location.tintColor = .black
        stackView.addArrangedSubview(location)
        stackView.addArrangedSubview(label)
        return stackView
    }()
    
    private var statusV = NewFriendAdditionalLabel(of: "10",type: .lvl)
    private var vest = NewFriendAdditionalLabel(of: "50%",type: .match)
    
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
        addSubview(statusV)
        addSubview(vest)
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
            
            statusV.topAnchor.constraint(equalTo: newFriendTitleLabel.bottomAnchor, constant: 7),
            statusV.leadingAnchor.constraint(equalTo: newFriendTitleLabel.leadingAnchor),
            statusV.widthAnchor.constraint(equalToConstant: 41),
            statusV.heightAnchor.constraint(equalToConstant: 20),
            
            vest.leadingAnchor.constraint(equalTo: statusV.trailingAnchor,constant: 10),
            vest.centerYAnchor.constraint(equalTo: statusV.centerYAnchor),
            vest.widthAnchor.constraint(equalToConstant: 82),
            vest.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
       
}
