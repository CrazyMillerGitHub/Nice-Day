//
//  ActivtiyViewPresenter.swift
//  Nice Day
//
//  Created by Михаил Борисов on 15.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase

protocol ActivityCallable: class {
    
    var activityElement: Activity? { get }

    func dismiss(timestamps: [Timestamp], element: Activity?)
    func progress(_ progress: Double)
}

final class ActivityViewPresenter: NSObject, ActivtityDelegate {

    private var collectionView: UICollectionView!
    private var timestamps: [Timestamp]!
    private weak var delegate: ActivityCallable!

    init(collectionView: UICollectionView, delegate: ActivityCallable, timestamps: [Timestamp] = []) {
        self.collectionView = collectionView
        self.delegate = delegate
        self.timestamps = timestamps
        super.init()
        setupRelationship()
    }

    private func setupRelationship() {

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func dismissAnimation() {
        delegate.dismiss(timestamps: timestamps, element: delegate.activityElement)
    }

    func addTimestamp(timestamp: Timestamp) {
        timestamps.append(timestamp)
    }
}

extension ActivityViewPresenter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityViewCell.identifier, for: indexPath) as? ActivityViewCell else {
            return UICollectionViewCell()
        }
        cell.element = delegate.activityElement
        cell.delegate = self
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate.progress(Double(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
