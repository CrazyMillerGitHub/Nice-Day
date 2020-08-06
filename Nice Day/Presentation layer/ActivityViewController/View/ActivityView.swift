//
//  ActivityView.swift
//  Nice Day
//
//  Created by Михаил Борисов on 11.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CHIPageControl
import Firebase

final class ActivityView: UIViewController {

    private var presenter: ActivityViewPresenter!
    internal var activityElement: Activity?

    private enum Constans {

        case headerTop, headerWidth, headerHeight
        case pageBottom, pageWidth, pageHeight
        case collectionTop

        var value: CGFloat {
            switch self {
            case .headerTop:
                return 13
            case .headerWidth:
                return 32
            case .headerHeight:
                return 5
            case .pageBottom:
                return -24
            case .pageWidth:
                return 89
            case .pageHeight, .collectionTop:
                return 10
            }
        }
    }

    init(element: Activity?) {
        self.activityElement = element
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: collectionView
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).with { collectionView in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ActivityViewCell.self, forCellWithReuseIdentifier: ActivityViewCell.identifier)
    }
    
    // MARK: Создание bgView
    private func performView() {
        view.backgroundColor = UIColor.bgColor.withAlphaComponent(0.5)
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }

    // MARK: headerView
    private lazy var headerView = UIView().with { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .projectGreyColor
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
    }
    
    // MARK: pageControl
    private lazy var pageControl = CHIPageControlAleppo().with { pageControl in
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.radius = 4
        pageControl.tintColor = .gray
        pageControl.currentPageTintColor = .inverseColor
        pageControl.padding = 10
        // TODO: Second cell for activitity view
        pageControl.isHidden = true
    }

    override func loadView() {
        super.loadView()
        presenter = ActivityViewPresenter(collectionView: collectionView, delegate: self)
        self.performView()
        self.prepareUI()
        self.prepareConstraint()
    }
    
    // MARK: PrepareUI
    // Подготовка UI к работе
    private func prepareUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
    }

    /// Preparing constraints
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            //HeaderView constraint
            self.headerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constans.headerTop.value),
            self.headerView.widthAnchor.constraint(equalToConstant: Constans.headerWidth.value),
            self.headerView.heightAnchor.constraint(equalToConstant: Constans.headerHeight.value),
            //pageControl constraint
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: Constans.pageBottom.value),
            self.pageControl.widthAnchor.constraint(equalToConstant: Constans.pageWidth.value),
            self.pageControl.heightAnchor.constraint(equalToConstant: Constans.pageHeight.value),
            //collectionView constraint
            self.collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: Constans.collectionTop.value),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor, constant: -5)
        ])
    }

}

extension ActivityView: ActivityCallable {

    func dismiss(timestamps: [Timestamp], element: Activity?) {
        guard let element = element else { return }
        guard let timeStart = timestamps.first, let timeEnd = timestamps.last, timestamps.count == 2 else { return }

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }

        let database = Firestore.firestore()
        let total = (Int(timeEnd.seconds - timeStart.seconds) / 60) * Int(element.activityCost)
        guard total > 0 else { return }
        let value: [String: Any] = ["cost": element.activityCost,
                                    "timeStart": timeStart,
                                    "timeEnd": timeEnd,
                                    "total": total]
        DispatchQueue.global(qos: .background).async {
            database.collection("users").document(Auth.auth().currentUser!.uid).updateData(["usage" : FieldValue.arrayUnion([value])])
        }
        let backgroundContext = CoreDataManager.shared.context(on: .private)

        backgroundContext.perform {
            CoreDataManager.shared.insertActivity(on: backgroundContext, activity: value)
        }
    }

    func progress(_ progress: Double) {
        pageControl.progress = progress
    }
}
