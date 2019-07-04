//
//  HelloLabel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 04/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

final class HelloLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.text = "Hello! I’m\nyour friend,\nMike"
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        self.textColor = .black
        self.frame = CGRect(x: 20, y: frame.height / 2, width: frame.width, height: 140)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
