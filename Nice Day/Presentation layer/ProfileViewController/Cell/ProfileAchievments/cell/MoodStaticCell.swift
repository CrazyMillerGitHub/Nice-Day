//
//  MoodStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 10.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import PassKit

class MoodStaticCell: CoreCell {
    
    static var identifier = "moodStaticCell"
    
    // MARK: avgPrecent String
    lazy var avgPrecent: (Int) -> UIStackView = { str in
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2
        let precent = UILabel()
        precent.text = "\(str)%"
        precent.textAlignment = .center
        precent.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        let precentDescription = UILabel()
        precentDescription.text = "Happiness"
        precentDescription.textAlignment = .center
        precentDescription.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        precentDescription.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
        stackView.addArrangedSubview(precent)
        stackView.addArrangedSubview(precentDescription)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
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
    
    let stackView: UIStackView = {
          let stackView = UIStackView()
          stackView.axis = .vertical
          stackView.distribution = .equalSpacing
          stackView.alignment = .leading
          stackView.spacing = 15
          stackView.addArrangedSubview(EmotionLabel(text: "\(Int.random(in: 0...100))% Happy"))
          stackView.addArrangedSubview(EmotionLabel(text: "\(Int.random(in: 0...100))% Normal"))
          stackView.addArrangedSubview(EmotionLabel(text: "\(Int.random(in: 0...100))% Sad"))
          stackView.translatesAutoresizingMaskIntoConstraints = false
          return stackView
      }()
    
    /// подготовка CAShapeLayer к работе
    private func prepareShape() {
        let path = UIBezierPath(arcCenter: CGPoint(x: contentView.center.x - 90, y: contentView.center.y), radius: 40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        let shapeLayer = ProgressShapeLayer(shapePath: path, shapeType: .moodForeground)
        let bgLayer = ProgressShapeLayer(shapePath: path, shapeType: .moodBackground)
        contentView.layer.addSublayer(bgLayer)
        contentView.layer.addSublayer(shapeLayer)
        shapeLayer.add(basicAnimation(0.6), forKey: "urSoBasic")
        let stackView = avgPrecent(10)
        addSubview(stackView)
        NSLayoutConstraint.activate([
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant:  -90),
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        prepareShape()
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor,constant: 34.5),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
