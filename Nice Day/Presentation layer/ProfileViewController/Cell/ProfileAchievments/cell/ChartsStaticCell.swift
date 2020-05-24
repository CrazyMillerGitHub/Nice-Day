//
//  ChartsStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 16.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ChartsStaticCell: CoreCell {
    
    static let identifier = "chartsStaticCell"
    
    let charts: UIView = {
        let charts = ChartsView()
        charts.addLine(data: Array(0...6), color: .searchBarColor, label: "hidden")
        charts.translatesAutoresizingMaskIntoConstraints = false
        charts.layer.cornerRadius = 15
        return charts
    }()
    
    fileprivate func prepareConstraints() {
        NSLayoutConstraint.activate([
            charts.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: 20),
            charts.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: -10),
            charts.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            charts.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        ])
    }
    
    fileprivate let bgView: (CGRect, UIView) -> UIView = { frame,chart  in
        let view = UIView()
        view.frame = frame
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.addSubview(chart)
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = bgView(contentView.frame, charts)
        contentView.addSubview(view)
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
