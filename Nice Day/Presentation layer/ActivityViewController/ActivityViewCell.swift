//
//  ActivityViewCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 29.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Lottie
import Firebase

protocol ActivtityDelegate: class {

    func dismissAnimation()
    func addTimestamp(timestamp: Timestamp)
}

final class ActivityViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: ActivityViewCell.self)

    // MARK: - Prepare UI

    var element: Activity? {
        didSet {
            if let element = element {
                activityLabel.text = element.userLang
                if let dscrText = activityDescriptionLabel.text { activityDescriptionLabel.text = "\(element.activityCost)" + dscrText }
                heartView.setIsOn(true, animated: true)
            }
        }
    }

    // MARK: heartView
    private var heartView = AnimatedSwitch().with { animationView in
        animationView.animation = Animation.named("heartAnimation")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.setProgressForState(fromProgress: 0, toProgress: 1, forOnState: true)
        animationView.setProgressForState(fromProgress: 1, toProgress: 0, forOnState: false)
        animationView.frame.size.height = 28
        animationView.frame.size.width = 28
    }
    
    // MARK: activityLabel
    private var activityLabel = UILabel().with { label in
        label.textAlignment = .center
        label.textColor =  UIColor.inverseColor
        label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: startStopButton init
    private var startStopButton: StartStopButton = {
        return StartStopButton()
    }()

    weak var delegate: ActivtityDelegate?
    
    // MARK: timerLabel
    fileprivate var timerLabel = TimerLabel().with { label in
        label.textAlignment = .center
        label.textColor =  UIColor.sunriseColor
        label.text = "00:00:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: activityDescriptionLabel
    private var activityDescriptionLabel = UILabel().with { label in
        label.textAlignment = .center
        label.textColor = .inverseColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        loadView()
    }
    
    func loadView() {
        prepareTarget()
        prepareUI()
        prepareConstraint()
    }
    
    func prepareTarget() {
        heartView.addTarget(self, action: #selector(favouriteAction(sender:)), for: .touchUpInside)
        startStopButton.addTarget(self, action: #selector(startStopAction(sender:)), for: .touchUpInside)
    }
    
    func prepareUI() {
        self.contentView.addSubview(heartView)
        self.contentView.addSubview(activityLabel)
        self.contentView.addSubview(startStopButton)
        self.contentView.addSubview(timerLabel)
        self.contentView.addSubview(activityDescriptionLabel)
    }
    
    func prepareConstraint() {
        //activityLabel constraint
        NSLayoutConstraint.activate([
            self.activityLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.activityLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 21),
            //heartView constraint
            self.heartView.centerYAnchor.constraint(equalTo: self.activityLabel.centerYAnchor),
            self.heartView.leadingAnchor.constraint(equalTo: activityLabel.trailingAnchor, constant: 10),
            //startStopButton constraint
            self.startStopButton.widthAnchor.constraint(equalToConstant: 150),
            self.startStopButton.heightAnchor.constraint(equalToConstant: 42),
            self.startStopButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.startStopButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            //timerLabel constraint
            self.timerLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.timerLabel.topAnchor.constraint(equalTo: self.activityLabel.bottomAnchor, constant: 20),
            //activityDescriptionLabel constraint
            self.activityDescriptionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.activityDescriptionLabel.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor)
        ])
    }
    
    /// startStopAction
    /// - Parameter sender: any
    @objc
    private func startStopAction(sender: Any) {
        startStopButton.isSelected.toggle()
        startStopButton.isSelected ? timerLabel.createTimer() : timerLabel.cancelTimer()
        delegate?.addTimestamp(timestamp: Timestamp(date: Date()))
        if !startStopButton.isSelected {
            delegate?.dismissAnimation()
        }
    }
    
    @objc
    private func favouriteAction(sender: Any) {

//        let database = Firestore.firestore()
//        guard let element = element else { return }
//        database.collection("users").document(Auth.auth().currentUser!.uid).updateData(
//            ["favourite" : FieldValue.arrayUnion([
//                database.collection("activity").document(element.documentID)])])
    }
    
}
