//
//  AppDelegate.swift
//  CUPUS
//
//  Created by Ivan Rep on 21/02/17.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.rootViewController = TabViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

