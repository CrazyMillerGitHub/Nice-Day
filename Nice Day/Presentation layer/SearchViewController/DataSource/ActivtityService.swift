//
//  ActivtityService.swift
//  Nice Day
//
//  Created by Михаил Борисов on 23.06.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum NetworkError: Error {

    case collectionError, documentError, dataCorrupted
}

extension NetworkError: LocalizedError {

    var localizedDescription: String? {

        switch self {
        case .collectionError:
            return "Collection not found"
        case .documentError:
            return "Collection not Found"
        case .dataCorrupted:
            return "Data corrupted"
        }
    }
}

final class ActivtityService {

    let database = Firestore.firestore()

    func getActivities(handler: @escaping (Result<[ActivityElement], NetworkError>) -> Void) {

        database.collection("activity").addSnapshotListener(includeMetadataChanges: false) { (querySnapshot, err) in

            if let _ = err {
                handler(.failure(.collectionError))
            }

            guard let documents = querySnapshot?.documents else {
                handler(.failure(.documentError))
                return
            }

            let values: [ActivityElement] = documents.compactMap { (queryDocumentSnapshot) -> ActivityElement? in

                let data = queryDocumentSnapshot.data()

                guard
                    let activityCost = data["activity_cost"] as? String,
                    let activityType = data["activity_type"] as? String,
                    let enLang = data["en"] as? String,
                    let ruLang = data["ru"] as? String else {
                        return nil
                }

                return ActivityElement(activityCost: activityCost,
                                       activityType: activityType,
                                       enLang: enLang,
                                       ruLang: ruLang)
            }

            handler(.success(values))
        }
    }
}
