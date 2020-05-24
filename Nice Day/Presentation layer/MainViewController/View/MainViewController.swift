//
//  MainViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, UINavigationControllerDelegate {

    // creating properties
    private var customNavBar: CustomNavBar!
    private var collectionViewDataSource: MainViewDataSource?
    private var presenter: MainViewPresenter!

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
        customNavBar = CustomNavBar(imageView: &imageView, view: self)
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = MainViewDataSource(collectionView: collectionView, delegate: self)
        presenter = MainViewPresenter(view: self)
        presenter.fetchBricks()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func tapped() {
        // TODO: использовать router
        DispatchQueue.main.async {
            let profileView = ProfileView()
            profileView.isModalInPresentation = true
            self.present(profileView, animated: true, completion: nil)
        }
    }

}

extension MainViewController: BrickListView {

    internal func show(items: [MainItem]) {
        collectionViewDataSource?.items = items
    }
}
