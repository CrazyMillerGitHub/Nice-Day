//
//  ProfileView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class ProfileView: UIViewController {

    // MARK: - Configure instance
    enum Mode {
        case normal, achievment
    }

    private var profileMode: Mode!

    private var viewModel: ProfileViewModel!
    
    private var imagePicker: ImagePicker!
    
    private let navigationBar: UINavigationBar = UINavigationBar().with { (navigationBar) in
        let navigationItem = UINavigationItem(title: "_profile".localized)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.bgColor.withAlphaComponent(0.2)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAction(sender:)))
        navigationBar.setItems([navigationItem], animated: false)
    }

    private lazy var topView = UIView().with { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgColor
    }

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .secondGradientColor
        collectionView.register(AboutCell.self, forCellWithReuseIdentifier: AboutCell.identifier)
        collectionView.register(ProfileAchievmentsCell.self, forCellWithReuseIdentifier: ProfileAchievmentsCell.identifier)
        return collectionView
    }()

    init(viewModel: ProfileViewModel = ProfileViewModel(), mode: Mode = .normal) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.profileMode = mode
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .bgColor
        view.addSubview(collectionView)
        view.addSubview(navigationBar)
        collectionView.addSubview(topView)

        DispatchQueue.global(qos: .background).async {
            self.createObserver()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraint()

        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel

        if let mode = profileMode, mode == .achievment {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
            }
        }
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(signOutAction), name: .signOutNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(performPicker), name: .performPicker, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Настройка constraint
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

            // bottomView constraints
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 300),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    
    @objc
    private func dismissAction(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func signOutAction() {
        let onboardingView = OnboardingView()
        onboardingView.modalPresentationStyle = .fullScreen
        self.present(onboardingView, animated: true, completion: nil)
    }
    
    @objc
    func performPicker(_ sender: Any) {
        self.imagePicker.present(from: view)
    }
}
extension Notification.Name {
    static let signOutNotificationKey = Notification.Name(rawValue: "com.niceDay.signOutNotificationKey")
    static let performPicker = Notification.Name(rawValue: "con.niceDay.perfomPicker")
    static let moveAndResizeImage = Notification.Name(rawValue: "com.niceDay.moveAndResizeImage")
    static let removeMoodCell = Notification.Name(rawValue: "com.niceDay.removeMoodCell")
    static let showAlert = Notification.Name(rawValue:
        "com.niceDay.showAlert")
    static let showAwards = Notification.Name(rawValue: "com.niceDay.showAwards")
}

extension ProfileView: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if let image = image {
            print(image.size)
            // TODO: Загрузка фото на сервер или в CoreData
        }
    }
    
}
