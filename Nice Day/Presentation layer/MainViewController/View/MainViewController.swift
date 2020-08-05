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

final class MainViewController: UIViewController, UINavigationControllerDelegate, MainViewCallable {

    // creating properties
    private var customNavBar: CustomNavBar!
    private var presenter: MainViewPresenter!

    private var backgroundContext: NSManagedObjectContext {
        CoreDataManager.shared.context(on: .main)
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).with { collectionView in
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .bgColor
    }

    // MARK: imageView
    private lazy var imageView = UIImageView().with { imageView in
        let data = UserDefaults.standard.data(forKey: "imageView")
        imageView.image = data == nil ? #imageLiteral(resourceName: "profile_img.pdf") : UIImage(data: data!)
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.layer.borderWidth = 1
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    override func loadView() {
        super.loadView()
        presenter = MainViewPresenter(collectionView: collectionView, delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(showAward), name: .showAwards, object: nil)
        customNavBar = CustomNavBar(imageView: &imageView, view: self)
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func tapped() {
        // TODO: использовать router
        self.backgroundContext.perform {
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
            let profileView = ProfileView(mode: .achievment)
            profileView.isModalInPresentation = true
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.present(profileView, animated: true, completion: nil)
            }
        }
    }

}
