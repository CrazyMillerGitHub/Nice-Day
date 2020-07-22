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

        let backgroudContext = CoreDataManager.shared.context(on: .private)

        return true
    }

    private func checkUserLanguage(for key: String) {
        if (UserDefaults.standard.string(forKey: key) == nil) {
            UserDefaults.standard.setValue(NSLocale.current.languageCode, forKey: key)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        saveContext()
       // CoreDataManager.shared.saveContext()
    }
}

final class Helper {

    private init() {}

    static var shared = Helper()

    func debugPrint(_ items: Any...) {
        #if DEBUG
        print(items)
        #endif
    }
}
