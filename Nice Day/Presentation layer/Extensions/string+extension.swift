//
//  string+extension.swift
//  Nice Day
//
//  Created by Михаил Борисов on 20.10.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
extension String {
    func localized(withComment comment: String? = nil) -> String {
           return NSLocalizedString(self, comment: comment ?? "")
       }
}
