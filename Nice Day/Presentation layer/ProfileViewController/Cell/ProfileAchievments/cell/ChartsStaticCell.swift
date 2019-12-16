//
//  ChartsStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ChartsStaticCell: CoreCell {
    
    let charts: UIView = {
        let view = UIView()
        let charts = ChartsView()
        charts.addLine(data: Array(0...7), color: .searchBarColor, label: "hidden")
        charts.translatesAutoresizingMaskIntoConstraints = false
        return charts
    }()
    
    static let identifier = "chartsStaticCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = UIView()
        view.frame = contentView.frame
        view.layer.cornerRadius = 15
        contentView.addSubview(view)
        view.layer.masksToBounds = true
        charts.layer.cornerRadius = 15
        view.addSubview(charts)
        NSLayoutConstraint.activate([
            charts.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 20),
            charts.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: -10),
            charts.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            charts.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
