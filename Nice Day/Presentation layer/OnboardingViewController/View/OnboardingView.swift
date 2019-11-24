//
//  OnboardingViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 30/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CHIPageControl
import Lottie
class OnboardingView: UIViewController,UIScrollViewDelegate {
    
   fileprivate let stringArray = [NSLocalizedString("Do your daily activities", comment: ""),NSLocalizedString("Earn xp", comment: ""), NSLocalizedString("Be better every day!", comment: "")]
   fileprivate var progress: CGFloat =  0
    
    // animationView
   private var animationView: AnimationView = {
        let animationView = AnimationView(name: "onboarding")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    //headerLabel
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Welcome", comment: "")
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .inverseColor
        return label
    }()
    
    //logInButton
    let loginButton: ElasticButton = {
        let button = ElasticButton()
        button.setTitle(NSLocalizedString("_sign_in".localized(), comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.setTitleColor(UIColor.inverseColor, for: .normal)
        button.layer.shadowColor = UIColor.inverseColor.cgColor
        button.layer.shadowRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity = 0.1
        button.alpha = 0.0
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    //ScrollView
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    //pageControl
    let pageControl : CHIPageControlAleppo = {
        let pageControl = CHIPageControlAleppo()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.tintColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00)
        pageControl.currentPageTintColor = .inverseColor
        pageControl.padding = 10
        return pageControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if progress == 0 {
            animationView.play(fromProgress: 0, toProgress: 0.5, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .bgColor
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().shadowImage = UIImage()
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(),for:.default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        self.preformView()
        
        NSLayoutConstraint.activate([
            //headerlabel
            self.headerLabel.heightAnchor.constraint(equalToConstant: 38.0),
            self.headerLabel.widthAnchor.constraint(equalToConstant: 260),
            self.headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28.0),
            self.headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:72.0),
            
            //logInbuttonConstraint
            self.loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            self.loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -81),
            self.loginButton.widthAnchor.constraint(equalToConstant: 97.0),
            self.loginButton.heightAnchor.constraint(equalToConstant: 36.0),
            
            //pageControl
            self.pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.5),
            self.pageControl.widthAnchor.constraint(equalToConstant: 89.0 ),
            self.pageControl.heightAnchor.constraint(equalToConstant: 21.0),
            self.pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -125.0),
            //125
            
            //scrollView
            self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0),
            self.scrollView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, constant: -245),
            self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 118.0),
            
            //animationView
            self.animationView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 70),
            self.animationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            self.animationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            self.animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor, multiplier: 9/16)
        ])
        setupScrollView()
    }
    
    private func preformView() {
        view.addSubview(headerLabel)
        view.addSubview(animationView)
        view.addSubview(loginButton)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    @objc
    private func tappedButton() {
        DispatchQueue.main.async {
            let authVC = AuthViewController()
            authVC.modalPresentationStyle = .fullScreen
            self.present(authVC, animated: true, completion: nil)
        }
    }
    
    private func handlePan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let progress = translation.x / self.view.bounds.size.width * 0.75
        animationView.currentProgress = progress
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: scrollView.frame.size.height)
        for iii in 0 ... 2 {
            let label = UILabel()
            label.frame = CGRect(x: 30 + CGFloat(iii) * self.view.frame.size.width , y: 0, width: self.view.frame.width - 110, height: 19)
            label.textAlignment = .left
            label.text = stringArray[iii]
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            label.textColor = UIColor.inverseColor.withAlphaComponent(0.9)
            scrollView.addSubview(label)
            
        }
        self.view.bringSubviewToFront(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        progress = scrollView.contentOffset.x / scrollView.contentSize.width * 0.75 + 0.5
        pageControl.progress = Double(scrollView.contentOffset.x / scrollView.contentSize.width) * 3
        if progress < 0.5 { progress = 0.5 }
        if progress >= 1.0 {
            progress = 1.0
            if loginButton.isHidden {
                loginButton.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
                    self.loginButton.alpha = 1.0 })
            }
        }
        animationView.currentProgress = progress
    }
}
