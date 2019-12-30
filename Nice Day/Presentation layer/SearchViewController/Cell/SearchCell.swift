//
//  SearchCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

enum GradeStatus: CaseIterable {
       case active
       case passive
   }

class SearchCell: UITableViewCell {
    
    static var identifier: String = "Cell"
    
    var xpCount: Int?
    
    // MARK: textLabel
    let textTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .inverseColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: DescriptionLabel
    let dscrTitle: (Int) -> UILabel = { xpCount in
        let label = UILabel()
        let str = "\(xpCount) xp every minute"
        let attributedString = NSMutableAttributedString(string: str, attributes: [
          .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
          .foregroundColor: UIColor.inverseColor,
          .kern: -0.29
        ])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 12.0, weight: .bold),
            .foregroundColor: UIColor.green
        ], range: NSRange(location: String(xpCount).count + 1, length: 2))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: StackView
    let stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    fileprivate var statusGrade: (GradeStatus) -> UIImageView = { imageName in
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.frame.size.height = 16
        imageView.frame.size.width = 16
        imageView.image = UIImage(named: imageName == .active ? "activeGrade" : "passiveGrade")
        return imageView
    }
    
    // MARK: HorizontalStackView
    let horizontalStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate func prepareConstraints() {
        NSLayoutConstraint.activate([
            // stackView constraints
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .bgColor
        self.accessoryType = .disclosureIndicator
        horizontalStackView.addArrangedSubview(statusGrade(.active))
        horizontalStackView.addArrangedSubview(dscrTitle(xpCount ?? 0))
        stackView.addArrangedSubview(textTitle)
        stackView.addArrangedSubview(horizontalStackView)
        self.addSubview(stackView)
        prepareConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
