//
//  FriendCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import PassKit

class AchievmentCell: UICollectionViewCell {
    
    static var achievmentIdentifier = "AchievmentCell"
    
    // MARK: FriendLabel
    fileprivate var achievmentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "ddef"
        label.textAlignment = .left
        return label
    }()
    
    // MARK: FriendLabel
    fileprivate var achievmentDscrLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "ddef"
        label.textColor = UIColor.black.withAlphaComponent(0.52)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: AchievmentView
    fileprivate var achievmentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.sunriseColor.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        refresh()
    }
    
    private func prepareUI() {
        addSubview(achievmentView)
        addSubview(achievmentLabel)
        addSubview(achievmentDscrLabel)
    }
    
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            
            self.achievmentView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.achievmentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.achievmentView.widthAnchor.constraint(equalToConstant: 48),
            self.achievmentView.heightAnchor.constraint(equalToConstant: 48),
            
            self.achievmentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.achievmentLabel.leadingAnchor.constraint(equalTo: self.achievmentView.trailingAnchor, constant: 8),
            
            self.achievmentDscrLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.achievmentDscrLabel.leadingAnchor.constraint(equalTo: self.achievmentLabel.leadingAnchor)
        ])
    }
    
    private func refresh() {
        prepareUI()
        prepareConstraint()
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: .zero, radius: 24, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        shapeLayer.path = path
        shapeLayer.position = CGPoint(x: 32, y: 24.5)
        shapeLayer.fillColor = #colorLiteral(red: 0.1960784314, green: 0.8, blue: 0.3882352941, alpha: 1).withAlphaComponent(0.2).cgColor
        self.contentView.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.25
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        shapeLayer.add(animation, forKey: nil)
        
    }
}
