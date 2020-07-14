//
//  MoodCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Coordinator

// MARK: - MoodCell
final class MoodCell: CoreCell {

    enum Emotion: Int {
        case good, neutral, bad
    }

    static var identifier: String = String(describing: type(of: self))

    // MARK: Close Button (отмена измерения настроения на день)
    private let closeButton = UIButton().with { button in
        button.backgroundColor = .sunriseColor
        button.setImage(UIImage(named: "close"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.sunriseColor.cgColor
        button.layer.shadowRadius = 16.0
        button.layer.shadowOpacity = 0.14
        button.layer.shadowOffset = CGSize(width: 0, height: 16)
        button.layer.masksToBounds = false
    }

    // MARK: CollectionView
    // CollectionView для эмоций
    let moodCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(EmotionCell.self, forCellWithReuseIdentifier: EmotionCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        moodCollectionView.collectionViewLayout = createLayout()
        contentView.addSubview(moodCollectionView)
        contentView.addSubview(closeButton)
        moodCollectionView.delegate = self
        moodCollectionView.dataSource = self
        closeButton.addTarget(self, action: #selector(notifyToHideAction), for: .touchUpInside)
        prepareConstraint()
    }
    
    @objc
    private func notifyToHideAction() {
        NotificationCenter.default.post(name: .removeMoodCell, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            
            closeButton.widthAnchor.constraint(equalToConstant: 46),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            moodCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moodCollectionView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            moodCollectionView.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor),
            moodCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

}
extension MoodCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var emotionName: String

        guard let emotion = Emotion(rawValue: indexPath.row) else { return }

        switch emotion {
        case .good:
            emotionName = "good"
        case .bad:
            emotionName = "bad"
        case .neutral:
            emotionName = "neutral"
        }

        // check if current user exist
        guard let curentUser = Auth.auth().currentUser else {
            return
        }

        // apply changes in dataset
        let database = Firestore.firestore()
        database.collection("users").document(curentUser.uid).updateData(["moods": FieldValue.arrayUnion([emotionName])]) { (error) in
            if let error = error {
                NotificationCenter.default.post(name: .showAlert, object: [error.localizedDescription], userInfo: nil)
                return
            }
            self.notifyToHideAction()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell.identifier, for: indexPath) as? EmotionCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = UIImage(named: "emoji\(indexPath.row + 1)")
        return cell
    }
}
