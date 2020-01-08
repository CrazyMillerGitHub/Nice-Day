//
//  AboutCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AboutCell: UICollectionViewCell {
    
    static var identifier = "about"
    
    var headerView: ProfileHeader!
    
    // MARK: создание imageView
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 45.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: SignOut Button
    let signOutButton: ElasticButton = {
        let button = ElasticButton()
        button.backgroundColor = .sunriseColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.setTitle("_signOut".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return button
    }()
    
   // MARK: levelStackView
    fileprivate let levelStackView = CustomStackView(
        elements: [CustomInfoLabel(labelType: .description, labelText: "_level"),
                   CustomInfoLabel(labelType: .value, labelText: Int.random(in: 0...100))],
        stackViewAxis: .vertical,
        spacingCount: 8)
    
    // MARK: xpStackView
    fileprivate let xpStackView = CustomStackView(
        elements: [CustomInfoLabel(labelType: .description, labelText: "_xp"),
        CustomInfoLabel(labelType: .value, labelText: Int.random(in: 0...1000))],
        stackViewAxis: .vertical,
        spacingCount: 8)
    
    // MARK: stackView
    fileprivate let stackView = CustomStackView(elements: nil, stackViewAxis: .horizontal, spacingCount: 35)
    
    // MARK: basicAnimationInit
    fileprivate let basicAnimation: (CGFloat) -> CABasicAnimation = { toValue in
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
        let headerView = ProfileHeader()
        
        stackView.addArrangedSubview(levelStackView)
        stackView.addArrangedSubview(xpStackView)
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(headerView)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(signOutButton)
        self.headerView = headerView
        prepareGesture()
        prepareConstraint()
        reset()
        prepareShape()
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
        signOutButton.addAction {
            self.signOutAction()
        }
    }
    
    @objc
    private func signOutAction() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        NotificationCenter.default.post(name: .signOutNotificationKey, object: nil)
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
            
            self.stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
            self.stackView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: -10),
            self.stackView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 10),
            self.stackView.heightAnchor.constraint(equalToConstant: 45),
            
            //SignOutButton Constraints
            self.signOutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            self.signOutButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.signOutButton.heightAnchor.constraint(equalToConstant: 46),
            self.signOutButton.widthAnchor.constraint(equalToConstant: 143)
            
        ])
    }
    
    func prepareGesture() {
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
    }
    
    @objc
    func tapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .performPicker, object: nil)
    }
}
