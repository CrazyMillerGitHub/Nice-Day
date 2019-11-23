//
//  MoodStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 10.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class MoodStaticCell: CoreCell {
    
    static var identifier = "moodStaticCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
