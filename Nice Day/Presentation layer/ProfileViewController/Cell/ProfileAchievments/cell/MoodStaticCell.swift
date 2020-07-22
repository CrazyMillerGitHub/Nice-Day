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
    
    static var identifier = String(describing: MoodStaticCell.self)
    
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
          stackView.translatesAutoresizingMaskIntoConstraints = false
          return stackView
      }()

    func fetchUserMood() {

        if let moods = currentUser.moods?.allObjects as? [Mood] {
            let moodCount = moods.compactMap { $0.count }.reduce(0, +)
            if moodCount > 0, let goodCount = moods.first(where: { mood in mood.name == "good" })?.count,
                let neutralCount = moods.first(where: { mood in mood.name == "neutral" })?.count,
                let badCount = moods.first(where: { mood in mood.name == "bad" })?.count {
                stackView.addArrangedSubview(EmotionLabel(text: "\(goodCount / moodCount * 100)% Happy"))
                stackView.addArrangedSubview(EmotionLabel(text: "\(neutralCount / moodCount * 100)% Normal"))
                stackView.addArrangedSubview(EmotionLabel(text: "\(badCount / moodCount * 100)% Sad"))
                prepareShape(precentage: CGFloat(goodCount / moodCount * 100))
            }
        }
    }
    
    /// подготовка CAShapeLayer к работе
    private func prepareShape(precentage: CGFloat) {
        let path = UIBezierPath(arcCenter: CGPoint(x: contentView.center.x - 90, y: contentView.center.y), radius: 40, startAngle: -CGFloat.pi / 2, endAngle: 3/2 * CGFloat.pi, clockwise: true).cgPath
        let shapeLayer = ProgressShapeLayer(shapePath: path, shapeType: .moodForeground)
        let bgLayer = ProgressShapeLayer(shapePath: path, shapeType: .moodBackground)
        contentView.layer.addSublayer(bgLayer)
        contentView.layer.addSublayer(shapeLayer)
        shapeLayer.add(basicAnimation(precentage), forKey: "urSoBasic")
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
        fetchUserMood()
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor,constant: 34.5),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
