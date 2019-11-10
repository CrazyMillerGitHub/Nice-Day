//
//  MoodCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MoodCell: CoreCell {
    
    static var identifier: String = "mood"
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? MoodCellModelItem else { return }
            cellTitleLabel.text = item.titleText
        }
        
    }
    
    // MARK: Close Button (отмена измерения настроения на день)
    let closeButton: UIButton = {
        let button = UIButton()
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
        button.addTarget(self, action: #selector(closeButtonAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: CollectionView
    // CollectionView для эмоций
    let moodCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentView.addSubview(moodCollectionView)
        contentView.addSubview(closeButton)
        moodCollectionView.register(EmotionCell.self, forCellWithReuseIdentifier: EmotionCell.identifier)
        moodCollectionView.delegate = self
        moodCollectionView.dataSource = self
        prepareConstraint()
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
                   
                   moodCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                   moodCollectionView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor),
                   moodCollectionView.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor),
                   moodCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
               ])
    }
    
    @objc
    private func closeButtonAction(sender: Any) {
        
    }
}
extension MoodCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: 58, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 50, bottom: 0, right: 10)
    }
    
}
