//
//  TestViewController.swift
//  Nice Day
//
//  Created by Михаил Борисов on 31.03.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                if let email = user.email {
                    print("Successfully logged into Firebase with Sign in with Apple\n\nuser.id: \(user.uid)\nuser.email: \(email)\nauth: \(auth)")
                }
            }
        }
    }
}
