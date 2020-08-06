//
//  MoodStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 10.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class AverageStackView<T> where T: Numeric & CVarArg {

    private(set) var precentageCount: T

    private(set) var stackView: UIStackView

    private lazy var precentCountLabel: UILabel = UILabel().with { label in
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
    }

    private lazy var precentageDescription: UILabel = UILabel().with { label in
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1)
        label.text = "Happiness"
    }

    init(stackView: UIStackView) {
        self.stackView = stackView
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.precentageCount = 0
    }

    internal func addPrecentage(_ count: T) {
        precentCountLabel.text = "\(count)%"
        configureStackView()
    }

    private func configureStackView() {
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(precentCountLabel)
        stackView.addArrangedSubview(precentageDescription)
    }

}

final class MoodStaticCell: CoreCell {
    
    static var identifier = String(describing: MoodStaticCell.self)
    
    // MARK: avgPrecent String
    private lazy var avgPrecentStackView = AverageStackView<Int>(stackView: UIStackView())
    
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
    
    private lazy var stackView = UIStackView().with { stackView in
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func fetchUserMood() {

        let backgroundContext = CoreDataManager.shared.context(on: .private)

        backgroundContext.perform {
            if let moods = CoreDataManager.shared.currentUser(backgroundContext).moods?.allObjects as? [Mood] {
                let moodCount = moods.compactMap { $0.count }.reduce(0, +)
                if moodCount > 0,
                    let goodCount = moods.first(where: { mood in mood.name == "good" })?.count,
                    let neutralCount = moods.first(where: { mood in mood.name == "neutral" })?.count,
                    let badCount = moods.first(where: { mood in mood.name == "bad" })?.count {
                    DispatchQueue.main.async {
                        self.stackView.addArrangedSubview(EmotionLabel(text: "\(Int(goodCount / moodCount * 100))% Happy"))
                        self.stackView.addArrangedSubview(EmotionLabel(text: "\(Int(neutralCount / moodCount * 100))% Normal"))
                        self.avgPrecentStackView.addPrecentage(Int(goodCount / moodCount * 100))
                        self.stackView.addArrangedSubview(EmotionLabel(text: "\(Int(badCount / moodCount * 100))% Sad"))
                        self.prepareShape(precentage: CGFloat(goodCount / moodCount))
                    }
                }
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        addSubview(avgPrecentStackView.stackView)
        fetchUserMood()
        
        DispatchQueue.main.async { [weak self] in
            self?.prepareConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MoodStaticCell {

    private func prepareConstraints() {
        NSLayoutConstraint.activate([
            avgPrecentStackView.stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant:  -90),
            avgPrecentStackView.stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 34.5),
            stackView.centerYAnchor.constraint(equalTo: avgPrecentStackView.stackView.centerYAnchor)
        ])
    }
}
