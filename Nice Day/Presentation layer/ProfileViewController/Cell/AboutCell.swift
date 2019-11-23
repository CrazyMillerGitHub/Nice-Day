//
//  AboutCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
class DescriptionLabel: UILabel {
    
    init(textStr: String) {
        super.init(frame: .zero)
        text = textStr.localized()
        contentMode = .center
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CountLabel: UILabel {
    
    init(number: Int) {
        super.init(frame: .zero)
        contentMode = .center
        font = UIFont.systemFont(ofSize: 18, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .inverseColor
        checkNumber(of: number)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkNumber(of number: Int) {
       text = "\(number)"
    }
}

class VStackView: UIStackView {
    
    init(elements: [UILabel]) {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        alignment = .center
        spacing = 8
        elements.forEach { addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 35
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol YourCellDelegate: class {
    func didCompleteOnboarding()
}

class AboutCell: UICollectionViewCell {
    
    static var identifier = "about"
    
    var delegate: YourCellDelegate?
    
    var headerView: ProfileHeaderView!
    
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
    
    // MARK: SignOut Button
    let signOutButton: ElasticButton = {
        let button = ElasticButton()
        button.backgroundColor = .sunriseColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        button.setTitle("_signOut".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
    // MARK: levelStackView
    let levelStackView = VStackView(elements: [DescriptionLabel(textStr: "_level"), CountLabel(number: Int.random(in: 0...100))])
    
    // MARK: xpStackView
    let xpStackView = VStackView(elements: [DescriptionLabel(textStr: "_xp"), CountLabel(number: Int.random(in: 0...100000))])
    
     // MARK: stackView
    let stackView = HStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let headerView = ProfileHeaderView()
        
        stackView.addArrangedSubview(levelStackView)
        stackView.addArrangedSubview(xpStackView)
        
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(signOutButton)
        self.headerView = headerView
        
        NSLayoutConstraint.activate([
            
            self.headerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 35.0),
            
            self.imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 116),
            self.imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 91.0),
            self.imageView.heightAnchor.constraint(equalToConstant: 91.0),
            
            self.stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            self.stackView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: -10),
            self.stackView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 10),
            self.stackView.heightAnchor.constraint(equalToConstant: 45),
            
            //SignOutButtonConstraints
            self.signOutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            self.signOutButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.signOutButton.heightAnchor.constraint(equalToConstant: 46),
            self.signOutButton.widthAnchor.constraint(equalToConstant: 143)
            
        ])
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        self.contentView.backgroundColor = .bgColor
    }
    
    @objc
    private func signOutAction() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        delegate?.didCompleteOnboarding()
    }
    
}

class ProfileHeaderView: UIView {
    
    override func draw(_ rect: CGRect) {
        ProfileHeader.drawCanvas1(frame: self.bounds, resizing: .aspectFill)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        self.backgroundColor = .clear
    }
}
