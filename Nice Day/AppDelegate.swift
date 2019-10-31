//
//  AppDelegate.swift
//  Nice Day
//
//  Created by Михаил Борисов on 03/07/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //application.isStatusBarHidden = false
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().shadowImage = nil
        UINavigationBar.appearance().tintColor = .inverseColor

        window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaults.standard.object(forKey: "loggedIn") == nil || UserDefaults.standard.object(forKey: "loggedIn") as? Bool == false {
            window?.rootViewController = OnboardingViewController()
            UserDefaults.standard.set(true, forKey: "loggedIn")
        } else {
            window?.rootViewController = SupportView()
        }
        window?.makeKeyAndVisible()

        return true
    }
}
