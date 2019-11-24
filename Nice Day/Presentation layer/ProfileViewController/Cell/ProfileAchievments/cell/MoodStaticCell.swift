//
//  MoodStaticCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 10.11.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import PassKit

class MoodStaticCell: CoreCell {
    
    static var identifier = "moodStaticCell"
    
    lazy var passButton: PKAddPassButton = {
        let passButton = PKAddPassButton(addPassButtonStyle: PKAddPassButtonStyle.black)
        passButton.frame.size.width = 280
        passButton.frame.size.height = 60
        return passButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        passButton.center = contentView.center
        addSubview(passButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
