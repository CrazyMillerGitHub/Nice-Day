//
//  AboutCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Combine

protocol Streamable {

    associatedtype Output

    var outputStream: PassthroughSubject<Output, Never> { get }

}

final class AboutCell: UICollectionViewCell, Streamable {

    internal var currentUser: User!

    typealias Output = SubjectType

    static var identifier = String(describing: AboutCell.self)
    
    private lazy var headerView: ProfileHeader = {
        return ProfileHeader()
    }()

    internal enum SubjectType {
        case disconnect, picker
    }

    internal let outputStream = PassthroughSubject<Output, Never>()
    
    // MARK: создание imageView
    private lazy var imageView =  UIImageView().with { imageView in
        imageView.layer.cornerRadius = 45.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .sunriseColor
        imageView.isUserInteractionEnabled = true
    }
    
    // MARK: SignOut Button
    private lazy var signOutButton = ElasticButton().with { button in
        button.backgroundColor = .sunriseColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("_signOut".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
   // MARK: levelStackView
    private lazy var levelStackView = CustomStackView(
        elements: [CustomInfoLabel(labelType: .description, labelText: "_level".localized),
                   CustomInfoLabel(labelType: .value, labelText: Int.random(in: 0...100))],
        stackViewAxis: .vertical,
        spacingCount: 8)
    
    // MARK: xpStackView
    private lazy var xpStackView = CustomStackView(
        elements: [CustomInfoLabel(labelType: .description, labelText: "_xp".localized),
        CustomInfoLabel(labelType: .value, labelText: Int.random(in: 0...1000))],
        stackViewAxis: .vertical,
        spacingCount: 8)
    
    // MARK: userName
    private lazy var userNameLabel = UILabel().with { label in
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .inverseColor
        label.textAlignment = .center
    }
    
    // MARK: stackView
    lazy private var stackView = CustomStackView(elements: nil, stackViewAxis: .horizontal, spacingCount: 35)
    
    // MARK: basicAnimationInit
    private let basicAnimation: (CGFloat) -> CABasicAnimation = { toValue in
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fillMode = .forwards
        basicAnimation.toValue = toValue
        basicAnimation.duration = 2
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return basicAnimation
    }
    
    private func prepareShape() {
        let path = UIBezierPath(arcCenter: CGPoint(x: contentView.center.x, y: contentView.center.y - 50.5 ), radius: 45, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        let shapeLayer = ProgressShapeLayer(shapePath: path, shapeType: .foreground)
        let bgLayer = ProgressShapeLayer(shapePath: path, shapeType: .background)
        contentView.layer.addSublayer(bgLayer)
        contentView.layer.addSublayer(shapeLayer)
        shapeLayer.add(basicAnimation(0.3), forKey: "urSoBasic")
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(levelStackView)
        stackView.addArrangedSubview(xpStackView)
        contentView.addSubview(stackView)
        contentView.addSubview(headerView)
        contentView.addSubview(imageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(signOutButton)

        prepareGesture()
        prepareConstraint()
        reset()
        prepareShape()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func configure() {
        if let firstName = currentUser.firstName?.capitalized, let lastName = currentUser.lastName?.capitalized {
            userNameLabel.text = "\(firstName) \(lastName)"
        }
        if let usages = currentUser.usages?.allObjects as? [Usage] {
            let result = usages.compactMap { $0.total }.reduce(0, +)
            levelStackView.elements?.last?.text = "\(getLevel(result))"
            xpStackView.elements?.last?.text = "\(result)"
        }
    }

    func getLevel(_ xpCount: Int32) -> Int32 {
        var lvl: Int32 = 1
        while xpCount > 100 ^ lvl {
            lvl += 1
        }
        return lvl
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        self.contentView.backgroundColor = .bgColor
        signOutButton.addAction {
            self.signOutAction()
        }
    }
    
    @objc private func signOutAction() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        outputStream.send(.disconnect)
    }
    
    @objc private func imagePickerAction(_ sender: UITapGestureRecognizer) {
        outputStream.send(.picker)
    }
}

extension AboutCell: UIGestureRecognizerDelegate {
    
    func prepareConstraint() {
        NSLayoutConstraint.activate([
            
            self.headerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 35.0),
            
            self.imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 116),
            self.imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 91.0),
            self.imageView.heightAnchor.constraint(equalToConstant: 91.0),
            
            self.userNameLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            self.userNameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            self.stackView.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 10),
            self.stackView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: -30),
            self.stackView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 30),
            self.stackView.heightAnchor.constraint(equalToConstant: 45),
            
            //SignOutButton Constraints
            self.signOutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            self.signOutButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.signOutButton.heightAnchor.constraint(equalToConstant: 46),
            self.signOutButton.widthAnchor.constraint(equalToConstant: 143)
            
        ])
    }
    
    func prepareGesture() {
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePickerAction(_:))))
    }
}
