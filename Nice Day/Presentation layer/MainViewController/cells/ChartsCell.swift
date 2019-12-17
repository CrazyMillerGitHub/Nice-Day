//
//  ChartsCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ChartsCell: CoreCell {
    static var identifier: String = "charts"
    
    // MARK: Charts
    let charts: UIView = {
        let view = UIView()
        let charts = ChartsView()
        charts.addLine(data: Array(0...6), color: .sunriseColor, label: "You")
        charts.addLine(data: Array(0...6), color: .secondGradientColor, label: "AVG")
        charts.translatesAutoresizingMaskIntoConstraints = false
        return charts
    }()
    
    var item: MainViewModelItem? {
        didSet {
            guard let item = item as? ChartsCellModelItem else { return }
            cellTitleLabel.text = item.titleText
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refresh() {
        let view = UIView(frame: contentView.frame)
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        addSubview(view)
        view.addSubview(charts)
        NSLayoutConstraint.activate([
            charts.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 20),
            charts.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: -10),
            charts.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            charts.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}
