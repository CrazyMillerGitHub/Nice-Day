//
//  AlertService.swift
//  Nice Day
//
//  Created by Михаил Борисов on 30.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(title: String, body: String, button: String) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "AlertViewController", bundle: .main)
        
        guard let alertVC = storyboard.instantiateViewController(identifier: "AlertVC") as? AlertViewController else {
            return AlertViewController()
        }
        
        alertVC.titleLabelString = title
        alertVC.descriptionLabelString = body
        alertVC.actionButtonString = button
        
        return alertVC
    }
}
