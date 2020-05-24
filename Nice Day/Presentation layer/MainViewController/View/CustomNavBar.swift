//
//  CustomNavBar.swift
//  Nice Day
//
//  Created by Михаил Борисов on 13.05.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol PresentableDelegate: class {
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
}

class CustomNavBar: NSObject {

    private var imageView: UIImageView
    private var view: UIViewController

    weak var delegate: PresentableDelegate?

    private enum Const {
        static let imageSizeForLargeState: CGFloat = 32
        static let imageRightMargin: CGFloat = 16
        static let imageBottomMarginForLargeState: CGFloat = 12
        static let imageBottomMarginForSmallState: CGFloat = 6
        static let imageSizeForSmallState: CGFloat = 25
        static let navBarHeightSmallState: CGFloat = 44
        static let navBarHeightLargeState: CGFloat = 96.5
    }

init(imageView: inout UIImageView, view: UIViewController) {
        self.view = view
        self.imageView = imageView
        super.init()
        setupNavBar()
        createObserver()
    }

    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveAndResizeImage), name: .moveAndResizeImage, object: nil)
    }

    @objc func moveAndResizeImage() {

        guard let height = view.navigationController?.navigationBar.frame.height else { return }
        let coeff: CGFloat = {
            let delta = height - Const.navBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.navBarHeightLargeState - Const.navBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.imageSizeForSmallState / Const.imageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.imageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.imageBottomMarginForLargeState - Const.imageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.imageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }

    private func configureImage(image: UIImage?) {
        if let image = image {
            imageView.image = image
        }
    }

    private func setupNavBar() {
        view.navigationController?.navigationBar.backgroundColor = .bgColor
        view.extendedLayoutIncludesOpaqueBars = true
        view.navigationController?.navigationBar.isTranslucent = true
        view.navigationController?.navigationBar.topItem?.title = "Nice Day"
        view.navigationController?.navigationBar.shadowImage = UIImage()
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = view.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.imageSizeForLargeState / 2
        NSLayoutConstraint.activate([

            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.imageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.imageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.imageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)

        ])
    }
}
