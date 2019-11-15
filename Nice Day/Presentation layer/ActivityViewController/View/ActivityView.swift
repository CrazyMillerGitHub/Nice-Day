//
//  ActivityView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 11.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CHIPageControl
import Lottie

class ActivityView: UIViewController {
    
    // MARK: Создание bgView
    private func performView() {
        self.view.backgroundColor = UIColor.bgColor.withAlphaComponent(0.5)
        let blurEffect = UIBlurEffect(style: isDarkModeActivated() ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    // MARK: headerView
    fileprivate var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .projectGreyColor
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: activityLabel
    fileprivate var activityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor =  UIColor.inverseColor
        label.text = "Sport"
        label.font = UIFont.systemFont(ofSize: 19, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: startStopButton
    fileprivate var startStopButton: ElasticButton = {
        let button = ElasticButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.sunriseColor.cgColor
        button.layer.masksToBounds = true
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        button.setTitleColor(.sunriseColor, for: .normal)
        button.addTarget(self, action: #selector(startStopAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: timerLabel
    fileprivate var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor =  UIColor.sunriseColor
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: activityDescriptionLabel
    fileprivate var activityDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .inverseColor
        label.text = "32 xp per min"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: pageControl
    fileprivate var pageControl : CHIPageControlAleppo = {
        let pageControl = CHIPageControlAleppo()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.radius = 4
        pageControl.tintColor = .gray
        pageControl.currentPageTintColor = .inverseColor
        pageControl.padding = 10
        return pageControl
    }()
    
    // MARK: heartView
    fileprivate var heartView: UIView = {
        return UIView()
    }()
    
    // MARK: PrepareUI
    // Подготовка UI к работе
    private func prepareUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(activityLabel)
        self.view.addSubview(startStopButton)
        self.view.addSubview(timerLabel)
        self.view.addSubview(activityDescriptionLabel)
        self.view.addSubview(pageControl)
    }
    
    /// Preparing constraints
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            //HeaderView constraint
            self.headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 13),
            self.headerView.widthAnchor.constraint(equalToConstant: 32),
            self.headerView.heightAnchor.constraint(equalToConstant: 5),
            //activityLabel constraint
            self.activityLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityLabel.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 31),
            //startStopButton constraint
            self.startStopButton.widthAnchor.constraint(equalToConstant: 150),
            self.startStopButton.heightAnchor.constraint(equalToConstant: 42),
            self.startStopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startStopButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            //timerLabel constraint
            self.timerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.timerLabel.topAnchor.constraint(equalTo: self.activityLabel.bottomAnchor, constant: 20),
            //activityDescriptionLabel constraint
            self.activityDescriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityDescriptionLabel.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor),
            //pageControl
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24),
            self.pageControl.widthAnchor.constraint(equalToConstant: 89.0 ),
            self.pageControl.heightAnchor.constraint(equalToConstant: 10.0)
        ])
    }
    
    override func loadView() {
        super.loadView()
        self.performView()
        self.prepareUI()
        self.prepareConstraint()
    }
    
    /// startStopAction
    /// - Parameter sender: any
    @objc
    private func startStopAction(sender: Any) {
        
    }
    
    private func isDarkModeActivated() -> Bool {
        if self.traitCollection.userInterfaceStyle == .dark {
            return true
        }
        return false
    }
    
}
