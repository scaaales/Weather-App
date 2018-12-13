//
//  CoreDataManager.swift
//  Weather App
//
//  Created by scales on 16.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static let sharedInstance = CoreDataManager()
    
    private init() {}
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
