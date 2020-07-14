//
//  AppDelegate.swift
//  Nice Day
//
//  Created by Михаил Борисов on 03/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().shadowImage = nil
        UITabBar.appearance().tintColor = .inverseColor
        UITabBar.appearance().unselectedItemTintColor = UIColor(red:0.87, green:0.87, blue:0.88, alpha:1.0)
        UITabBar.appearance().barTintColor = UIColor.bgColor.withAlphaComponent(0.2)
        UINavigationBar.appearance().tintColor = .inverseColor

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainView()
        window?.makeKeyAndVisible()

        FirebaseApp.configure()

//        let database = Firestore.firestore()

//        database.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
//            if let document = document, document.exists {
//
//                let refArray = document.get("Activities") as? [Any] ?? []
//                let ssss = (refArray.first as? [String: Any])!["startTime"] as? Timestamp
//                let rrrr = (refArray.first as? [String: Any])!["endTime"] as? Timestamp
//                print(Int((rrrr!.seconds - ssss!.seconds)/60))
//            } else {
//                print("Document does not exist")
//            }
//        }
        return true
    }

    private func checkUserLanguage(for key: String) {
        if (UserDefaults.standard.string(forKey: key) == nil) {
            UserDefaults.standard.setValue(NSLocale.current.languageCode, forKey: key)
        }
    }
}
