//
//  SpecialCell.swift
//  Nice Day
//
//  Created by Михаил Борисов on 06/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class SpecialCell: CoreCell {
    static var identifier: String = "special"
    
     var item: MainViewModelItem? {
           didSet {
               guard let item = item as? SpecialCellModelItem else { return }
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
       }
       override func prepareForReuse() {
           super.prepareForReuse()
           
       }
}
