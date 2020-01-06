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
    
    var status: GradeStatus = .active
    
    // MARK: textLabel
    let textTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .inverseColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: DescriptionLabel
    let dscrTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    fileprivate var statusGrade: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.frame.size.height = 16
        imageView.frame.size.width = 16
        return imageView
    }()
    
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
        
    }
    
    func prepareCell() {
        horizontalStackView.addArrangedSubview(statusGrade)
        horizontalStackView.addArrangedSubview(dscrTitle)
        stackView.addArrangedSubview(textTitle)
        stackView.addArrangedSubview(horizontalStackView)
        self.addSubview(stackView)
        prepareConstraints()
    }
    
    func setStatusGrade(_ status: GradeStatus) {
        statusGrade.image = UIImage(named: status == .active ? "activeGrade" : "passiveGrade")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareCell()
    }
}
