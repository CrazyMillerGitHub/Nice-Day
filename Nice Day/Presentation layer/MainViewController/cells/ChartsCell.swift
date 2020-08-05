//
//  ChartsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import Charts

final class ChartsCell: CoreCell {

    static var identifier: String = String(describing: ChartsCell.self)

    private var blurEffectView = UIVisualEffectView().with { blurEffectView in
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private var vibrancyView = UIVisualEffectView().with { blurEffectView in
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private var blurViewToggle: Bool = true {
        didSet {
            blurEffectView.isHidden = blurViewToggle
        }
    }

    // MARK: Charts
    private var charts = ChartsView().with { charts in
       // charts.addLine(data: Array(0...6), color: .secondGradientColor, label: "_AVG".localized())
        charts.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        CoreDataManager.shared.context(on: .main).perform {
            self.checkIfDataExist()
        }
    }

    private let view = UIView().with { view in
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        view.frame = contentView.frame
        blurEffectView.frame = view.bounds
        blurEffectView.effect = getBlurEffect()
        vibrancyView.frame = view.bounds
        vibrancyView.effect = getVibrancyEffect()

        let label = UILabel()
        label.text = "_later".localized
        label.font = UIFont().roundedFont(ofSize: .headline, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemBackground

        addSubview(view)
        view.addSubview(charts)
        vibrancyView.contentView.addSubview(label)
        blurEffectView.contentView.addSubview(vibrancyView)
        view.addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            charts.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 20),
            charts.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: -10),
            charts.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            charts.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    private func checkIfDataExist() {
        if let items = CoreDataManager.shared.fetchActivityForLast7Days(on: CoreDataManager.shared.context(on: .main)) {
            self.charts.addLine(data: items, color: .sunriseColor, label: "_YOU".localized())
            if items.keys.count > 1 {
                DispatchQueue.main.async {
                    self.blurViewToggle = true
                }
            }
        } else {
            DispatchQueue.main.async {
                self.blurViewToggle = true
            }
        }
    }

    private func getBlurEffect() -> UIBlurEffect {

        return UIBlurEffect(style: traitCollection.userInterfaceStyle == .light ? .regular : .dark)
    }

    private func getVibrancyEffect() -> UIVibrancyEffect {
        UIVibrancyEffect(blurEffect: getBlurEffect())
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        vibrancyView.effect = getVibrancyEffect()
        blurEffectView.effect = getBlurEffect()
    }
}

extension UIFont {

    func roundedFont(ofSize style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {

        let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
}
