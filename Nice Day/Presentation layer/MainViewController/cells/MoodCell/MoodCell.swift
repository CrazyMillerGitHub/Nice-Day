//
//  MoodCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase

// MARK: - MoodCell
final class MoodCell: CoreCell {

    enum Emotion: Int {
        case good, neutral, bad
    }

    private enum Constant {
        
        case size, buttonWidth

        var value: CGFloat {
            switch self {
            case .size:
                return 58
            case .buttonWidth:
                return 46
            }
        }
    }

    static var identifier: String = String(describing: type(of: MoodCell.self))

    // MARK: Close Button (отмена измерения настроения на день)
    private lazy var closeButton = UIButton().with { button in
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
        button.addTarget(self, action: #selector(notifyToHideAction), for: .touchUpInside)
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
        contentView.addSubview(moodCollectionView)
        contentView.addSubview(closeButton)
        moodCollectionView.delegate = self
        moodCollectionView.dataSource = self
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
            
            closeButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth.value),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            moodCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moodCollectionView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            moodCollectionView.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor),
            moodCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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

        database.collection("users").document(curentUser.uid).updateData(["moods.\(emotionName)" : FieldValue.increment(Int64(1))]) { err in
            
            if let err = err {
                print(err.localizedDescription)
            }

            CoreDataManager.shared.context(on: .private).perform { [weak self] in
                CoreDataManager.shared.incrementMood(on: CoreDataManager.shared.context(on: .private), with: CoreDataStack.MoodType(rawValue: emotionName)!)
                self?.updateMoodTime()
            }

            self.notifyToHideAction()
        }
    }

    private func updateMoodTime() {
        let currentUser = CoreDataManager.shared.currentUser(CoreDataManager.shared.context(on: .private))
        currentUser.moodTime = Date()
        CoreDataManager.shared.saveContext(backgroundContext: CoreDataManager.shared.context(on: .private))
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.size.value, height: Constant.size.value)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let spacing = (collectionView.frame.width - Constant.size.value * 3 - Constant.buttonWidth.value) / 3

        let padding = (collectionView.frame.height - Constant.size.value) / 2
        return UIEdgeInsets(top: padding, left: spacing, bottom: padding, right: spacing)
    }
    
}
