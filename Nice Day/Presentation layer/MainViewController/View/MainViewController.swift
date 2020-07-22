//
//  MainViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase
import CoreData

final class MainViewController: UIViewController, UINavigationControllerDelegate {

    // creating properties
    private var customNavBar: CustomNavBar!
    private var collectionViewDataSource: MainViewDataSource?
    private var presenter: MainViewPresenter!

    private var backgroundContext: NSManagedObjectContext {
        CoreDataManager.shared.context(on: .main)
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .bgColor
        return collectionView
    }()

    // MARK: imageView
    private lazy var imageView: UIImageView = {
        let data = UserDefaults.standard.data(forKey: "imageView")
        let imageView =  UIImageView(image: data == nil ? #imageLiteral(resourceName: "profile_img.pdf") : UIImage(data: data!))
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.layer.borderWidth = 1
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        return imageView
    }()

    override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self, selector: #selector(showAward), name: .showAwards, object: nil)
        customNavBar = CustomNavBar(imageView: &imageView, view: self)
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = MainViewDataSource(collectionView: collectionView, delegate: self)
        presenter = MainViewPresenter(view: self)
        DispatchQueue.global(qos: .background).async {
            self.presenter.fetchBricks()
        }

//        DispatchQueue.global(qos: .background).async {
//            CoreDataManager.shared.downloadUser { result in
//                switch result {
//                case .success(let user):
//                    print(user.firstName)
//                case .failure(let _):
//                    print("Nope")
//                }
//            }
//        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func tapped() {
        // TODO: использовать router
        self.backgroundContext.perform {
            [weak self] in
            guard let self = self else { return }
            let profileView = ProfileView()
            profileView.isModalInPresentation = true
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.present(profileView, animated: true, completion: nil)
            }
        }
    }

    @objc private func showAward() {
        self.backgroundContext.perform {
            [weak self] in
            guard let self = self else { return }
            let profileView = ProfileView(mode: .achievment)
            profileView.isModalInPresentation = true
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.present(profileView, animated: true, completion: nil)
            }
        }
    }

}

extension MainViewController: BrickListView {

    internal func show(items: [MainItem]) {
        collectionViewDataSource?.items = items
    }
}
