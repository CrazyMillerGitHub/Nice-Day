//
//  UserService.swift
//  Nice Day
//
//  Created by Михаил Борисов on 17.02.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase

class UserManager {
    
    static var shared = UserService()
    
    // creating singleton
    private init() {
        
    }
    
}

enum CompetionEnum {
    
    case success
    
    case failed
}

class UserService {
    
    func uploadImage(image: UIImage, completion: @escaping (CompetionEnum) -> Void) {
//        let storageRef = Storage.storage().reference().child("lock.img")
//        if let uploadImage = UIImage.pngData(image) {
//            storageRef.putData(<#T##uploadData: Data##Data#>)
//        }
    }
    
}
