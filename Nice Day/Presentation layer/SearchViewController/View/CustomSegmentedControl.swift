//
//  CustomSegmentedControl.swift
//  Nice Day
//
//  Created by Михаил Борисов on 17.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

//class CustomSegmentedControl: UISegmentedControl {
//    
//    var selectedSegmentedControlIndex: Int = 0
//    
//    init(items: [String] = []) {
//        super.init(frame: .zero)
//        backgroundColor = .clear
//        selectedSegmentTintColor = .sunriseColor
//        self.updateItems(items)
//        selectedSegmentIndex = selectedSegmentedControlIndex
//        setBackgroundImage(UIImage(), for: .focused, barMetrics: .default)
//        setTitleTextAttributes([
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)
//        ], for: .selected)
//        setTitleTextAttributes([
//            NSAttributedString.Key.foregroundColor: UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0),
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)
//        ], for: .normal)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func updateItems(_ items: [String]) {
//        for (index,item) in  items.enumerated() {
//            insertSegment(withTitle: item, at: index, animated: false)
//        }
//    }
//    
//}
