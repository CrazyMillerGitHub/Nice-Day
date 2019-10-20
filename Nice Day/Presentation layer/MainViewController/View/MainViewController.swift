//
//  MainViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ProfileImageViewProtocol {
    
    let imagePicker = UIImagePickerController()
    weak var collectionView: UICollectionView!

    func moveAndResizeImage() {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    let provider = MainViewModel()
    let delegate = MainViewControllerDelegate()
    
    /// imageView
    let imageView: UIImageView = {
        guard let data = UserDefaults.standard.data(forKey: "imageView") else { return UIImageView(image: #imageLiteral(resourceName: "profile_img.pdf"))}
        let imageView = UIImageView(image: UIImage(data: data))
        return imageView
    }()
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(pickedImage.pngData(), forKey: "imageView")
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
//func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
//    self.dismiss(animated: true, completion: { () -> Void in
//    })
//    imageView.image = image
//}
    override func loadView() {
         super.loadView()
               let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
                      collectionView.translatesAutoresizingMaskIntoConstraints = false
                      self.view.addSubview(collectionView)
               NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                   collectionView.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
               ])
                    
               self.collectionView = collectionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        //colors
        self.view.backgroundColor = .bgColor
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(ChartsCell.self, forCellWithReuseIdentifier: ChartsCell.identifier)
        self.collectionView.register(BonusCell.self, forCellWithReuseIdentifier: BonusCell.identifier)
        self.collectionView.register(FriendsCell.self, forCellWithReuseIdentifier: FriendsCell.identifier)
        self.collectionView.register(MoodCell.self, forCellWithReuseIdentifier: MoodCell.identifier)
        self.collectionView.register(SpecialCell.self, forCellWithReuseIdentifier: SpecialCell.identifier)
        self.collectionView.register(AchievmentsCell.self, forCellWithReuseIdentifier: AchievmentsCell.identifier)
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .bgColor
        navigationController?.navigationBar.backgroundColor = .bgColor
        //end colors
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        collectionView.dataSource = provider
        collectionView.delegate = delegate
        delegate.delegate = self
        setupUI()
        // Do any additional setup after loading the view.
    }
    
}
extension MainViewController {
    //Что тут происходит?
    private struct Const {
        static let ImageSizeForLargeState: CGFloat = 32
        static let ImageRightMargin: CGFloat = 16
        static let ImageBottomMarginForLargeState: CGFloat = 12
        static let ImageBottomMarginForSmallState: CGFloat = 6
        static let ImageSizeForSmallState: CGFloat = 25
        static let NavBarHeightSmallState: CGFloat = 44
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    private func setupUI() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = "Nice Day"
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
  
}
