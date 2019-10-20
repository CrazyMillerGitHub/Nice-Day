//
//  user.swift
//  Nice Day
//
//  Created by Михаил Борисов on 15/09/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import AuthenticationServices
struct UserStruct {
    let useIdentifier: String
    let firstName: String
    let lastName: String
    let email: String
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.useIdentifier = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email =  credentials.email ?? ""
    }
}
