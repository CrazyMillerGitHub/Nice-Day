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
class OnboardingViewController: UIViewController,UIScrollViewDelegate {
    let stringArray = [NSLocalizedString("Do your daily activities", comment: ""),NSLocalizedString("Earn xp", comment: ""), NSLocalizedString("Be better every day!", comment: "")]
   let animationView: AnimationView = {
        let animationView = AnimationView()
        let animation = Animation.named("onboarding_dark")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    var progress: CGFloat = 0
    
    let headerlabel: UILabel = {
        let label = UILabel()
        let screenSize: CGRect = UIScreen.main.bounds
        
        switch screenSize.width {
        case 320:
            label.frame = CGRect(x: 28, y: 72, width: 260, height: 38)
        default:
            label.frame = CGRect(x: 55, y: 108, width: 260, height: 38)
        }
        label.text = NSLocalizedString("Welcome", comment: "")
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .black

        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        let screenSize: CGRect = UIScreen.main.bounds
        switch screenSize.width {
        case 320:
            button.frame = CGRect(x: 18, y: screenSize.height - 81, width: 97, height: 36)
        default:
            button.frame = CGRect(x: 45, y: screenSize.height - 81, width: 97, height: 36)
        }
        
        button.setTitle(NSLocalizedString("Log in", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        // button.tintColor = .red
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity = 0.1
        button.backgroundColor = .white
        button.isHidden = true
        return button
    }()
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if progress == 0 {
            animationView.play(fromProgress: 0, toProgress: 0.5, completion: nil)
          
        }
    }
    let pageControl : CHIPageControlAleppo = {
        let pageControl = CHIPageControlAleppo()
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.tintColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00)
        pageControl.currentPageTintColor = .black
        pageControl.padding = 10
        return pageControl
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().shadowImage = UIImage()
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(),for:.default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        let screenSize: CGRect = UIScreen.main.bounds
        print("Screensize \(screenSize)")
        switch screenSize.width {
        case 320:
            
            scrollView.frame = CGRect(x: 0, y: 118, width: self.view.frame.size.width, height: self.view.frame.height - 245)
            pageControl.frame = CGRect(x: 25.5, y: screenSize.height - 125, width: 89, height: 21)
            animationView.frame = CGRect(x: 0, y: (headerlabel.frame.maxY + pageControl.frame.minY - screenSize.width/375*(220)) / 2, width: self.view.frame.size.width, height: screenSize.width/375*(220))
        default:
            
            scrollView.frame = CGRect(x: 0, y: 154, width: self.view.frame.size.width, height: self.view.frame.height - 281)
            pageControl.frame = CGRect(x: 48.5, y: screenSize.height - 125, width: 89, height: 21)
            animationView.frame = CGRect(x: 0, y: (headerlabel.frame.maxY + pageControl.frame.minY - screenSize.width/375*(220)) / 2, width: self.view.frame.size.width, height: screenSize.width/375*(220))
        }
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        view.addSubview(headerlabel)
        self.view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -30),
            animationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            animationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor, multiplier: 9/16)
        ])
        loginButton.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(loginButton)
        view.addSubview(scrollView)
        setupScrollView()
        view.addSubview(pageControl)
        loginButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func tappedButton() {
      //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "authView") as! authController
       // self.present(vc, animated: true, completion: nil)
    }
    func handlePan (recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let progress = translation.x / self.view.bounds.size.width * 0.75
        print(progress)
        animationView.currentProgress = progress
    }
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: scrollView.frame.size.height)
        for iii in 0 ... 2 {
            let label = UILabel()
            let screenSize: CGRect = UIScreen.main.bounds
            
            switch screenSize.width {
            case 320:
                label.frame = CGRect(x: scrollView.center.x + CGFloat(iii) * self.view.frame.size.width - (self.view.frame.width - 56) / 2, y: 0, width: self.view.frame.width - 56, height: 19)
            default:
                label.frame = CGRect(x: scrollView.center.x + CGFloat(iii) * self.view.frame.size.width - (self.view.frame.width - 110) / 2, y: 0, width: self.view.frame.width - 110, height: 19)
            }
            label.textAlignment = .left
            label.text = stringArray[iii]
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            label.textColor = UIColor.black.withAlphaComponent(0.9)
            scrollView.addSubview(label)
            
        }
        self.view.bringSubviewToFront(scrollView)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        progress = scrollView.contentOffset.x / scrollView.contentSize.width * 0.75 + 0.5
        pageControl.progress = Double(scrollView.contentOffset.x / scrollView.contentSize.width) * 3
        if progress < 0.5 {
            progress = 0.5
        }
        if progress >= 1.0 {
            progress = 1.0
           // loginButton.animate()
            loginButton.isHidden = false
        }
        animationView.currentProgress = progress
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
