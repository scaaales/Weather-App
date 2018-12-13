//
//  AppDelegate.swift
//  CoreData
//
//  Created by scales on 14.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		CitiesCoreDataManager.addDefaultCities()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
    
    
}

