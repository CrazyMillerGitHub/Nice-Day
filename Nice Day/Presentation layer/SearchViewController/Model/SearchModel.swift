//
//  SearchModel.swift
//  Nice Day
//
//  Created by Михаил Борисов on 29.12.2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

extension Activity {

    var userLang: String? {
        if let locale = Locale.current.languageCode, locale == "ru" {
            return ru
        } else {
            return en
        }
    }
}

struct ActivityElement: Decodable {

    let documentID: String
    let activityCost: Int
    let activityType: String
    let enLang: String
    let ruLang: String
    let popularity: Double

    private enum CodingKeys: String, CodingKey {

        case activityCost = "activity_cost"
        case activityType = "activity_type"
        case enLang = "en"
        case ruLang = "ru"
        case popularity
        case documentID
    }

}
