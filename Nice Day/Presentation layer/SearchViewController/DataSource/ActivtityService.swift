//
//  ActivtityService.swift
//  Nice Day
//
//  Created by Михаил Борисов on 23.06.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import Foundation
import Firebase
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

// MARK: - ActivtityService
final class ActivtityService {

    let database = Firestore.firestore()

    func fetchActivities(filter: [String] = [],
                         handler: @escaping (Result<[ActivityElement], NetworkError>) -> Void) {

        database.collection("activity").addSnapshotListener(includeMetadataChanges: false) { (querySnapshot, err) in
            // check if error is not null
            if err != nil {
                handler(.failure(.collectionError))
            }
            // check if documents exist
            guard var documents = querySnapshot?.documents else {
                handler(.failure(.documentError))
                return
            }

            if !filter.isEmpty {
                documents = documents.filter { (snapshot) -> Bool in
                    let data = snapshot.data()
                    if let value = data["en"] as? String {
                        return filter.contains(value)
                    }
                    return false
                }
            }
            // compactMap all dict to ActivityElement
            let activities: [ActivityElement] = documents.compactMap { (queryDocumentSnapshot) -> ActivityElement? in

                let data = queryDocumentSnapshot.data()
                // cast to ActivityElement (alternative Codable)
                guard
                    let activityCost = data["activity_cost"] as? Int,
                    let activityType = data["activity_type"] as? String,
                    let enLang = data["en"] as? String,
                    let ruLang = data["ru"] as? String,
                    let popularity = data["popularity"] as? Double else {
                        return nil
                }

                return ActivityElement(documentID: queryDocumentSnapshot.documentID,
                                       activityCost: activityCost,
                                       activityType: activityType,
                                       enLang: enLang,
                                       ruLang: ruLang,
                                       popularity: popularity)
            }

            handler(.success(activities))
        }
    }

    static func fetchFavouriteActvities(filter: [String],
                                        handler: @escaping (Result<[String], NetworkError>) -> Void) {
        
        let database = Firestore.firestore()

        guard let user = Auth.auth().currentUser?.uid else {
            return
        }

        let docRef = database.collection("users").document(user)

        docRef.getDocument { document, err in
            if let document = document, document.exists {

                if err != nil { handler(.failure(.dataCorrupted)) }

                let refArray = document.get("favourite") as? [DocumentReference] ?? []

                handler(.success(refArray.compactMap { String($0.path.split(separator: "/").last!) }))
            }
        }
    }
}
