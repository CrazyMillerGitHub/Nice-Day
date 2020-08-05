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

final class OnboardingView: UIViewController, OnboardingCallable {

    // MARK: animationView
    private var animationView = AnimationView(name: "onboarding").with { animationView in
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: headerLabel
    private lazy var headerLabel = UILabel().with { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("_welcome".localized(), comment: "")
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .inverseColor
    }

    // MARK: logInButton
    internal lazy var loginButton = ElasticButton().with { button in
        button.setTitle("_sign_in".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity = 0.10
        button.backgroundColor = UIColor.white
        button.layer.shadowRadius = 20
        button.alpha = 0.0
        button.addTarget(self, action: #selector(transitionAction(_:)), for: .touchUpInside)
        button.isHidden = true
    }

    // MARK: NewUserLabel init
    internal lazy var newUserLabel = UILabel().with { label in
        label.text = "_sign_up_description".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor.inverseColor.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.alpha = 0
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionAction(_:))))
    }

    // MARK: ScrollView
    private lazy var scrollView = UIScrollView().with { scroll in
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
    }

    // MARK: pageControl
    private lazy var pageControl = CHIPageControlAleppo().with { pageControl in
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.tintColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00)
        pageControl.currentPageTintColor = .inverseColor
        pageControl.padding = 10
    }

    private var presenter: OnboardingPresenter!
//     MARK: - UI cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if animationView.currentProgress == 0 {
            animationView.play(fromProgress: 0, toProgress: 0.5, completion: nil)
        }
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .bgColor
        DispatchQueue.main.async { [unowned self] in
            self.presenter = OnboardingPresenter(scrollView: self.scrollView, delegate: self, animationView: self.animationView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().shadowImage = UIImage()
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(),for:.default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        self.prepareUI()
        self.prepareConstraint()
        DispatchQueue.main.async { [weak self] in
            self?.prepareUI()
            DispatchQueue.main.async { [weak self] in
                self?.prepareConstraint()
            }
        }
    }

    private func prepareUI() {
        [headerLabel,
         animationView,
         loginButton,
         scrollView,
         pageControl,
         newUserLabel].forEach(view.addSubview(_:))
    }

    @objc private func transitionAction(_ sender: Any) {
        guard sender as? UIButton != nil else {
            presentView(authBehavior: .signUp)
            return
        }
        presentView(authBehavior: .signIn)
    }

    func setPageControlProgress(_ value: Double) {
          pageControl.progress = value
    }

    private func presentView(authBehavior: AuthViewController.AuthViewType) {
        DispatchQueue.main.async { [weak self] in
            let authVC = AuthViewController(authBehavior: authBehavior)
            authVC.modalPresentationStyle = .fullScreen
            self?.present(authVC, animated: true, completion: nil)
        }
    }

    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            headerLabel.heightAnchor.constraint(equalToConstant: 38.0),
            headerLabel.widthAnchor.constraint(equalToConstant: 260),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28.0),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:72.0),

            //logInbuttonConstraint
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            loginButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            loginButton.heightAnchor.constraint(equalToConstant: 46.0),

//            pageControl
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25.5),
            pageControl.widthAnchor.constraint(equalToConstant: 89.0 ),
            pageControl.heightAnchor.constraint(equalToConstant: 21.0),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -125.0),

//            scrollView
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -245),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 118.0),

//            animationView
            animationView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 70),
            animationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            animationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor, multiplier: 9/16),

//             newUserLabel
            newUserLabel.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor, constant: 46),
            newUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)

        ])
    }
}
