//
//  CitiesCoreDataManager.swift
//  Weather App
//
//  Created by scales on 17.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import Foundation
import PromiseKit
import CoreData


class CitiesCoreDataManager {
	private static let isDefaultCitiesAddedKey = "defaultCitiesAdded"
	
	private static var isDefaultCitiesAdded: Bool {
		set {
			UserDefaults.standard.set(newValue, forKey: isDefaultCitiesAddedKey)
		}
		get {
			return UserDefaults.standard.bool(forKey: isDefaultCitiesAddedKey)
		}
	}
	
    private init() {}
	
	static func addDefaultCities() {
		if !isDefaultCitiesAdded {
			let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
			let kiev = City(context: context)
			kiev.name = "Kiev"
			kiev.country = "UA"
			kiev.isFaved = true
			
			let odessa = City(context: context)
			odessa.name = "Odessa"
			odessa.country = "UA"
			odessa.isFaved = true
			
			CoreDataManager.sharedInstance.saveContext()
			isDefaultCitiesAdded = true
		}
	}
	
    static func getCityWith(id: Int64) -> City? {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "id == \(id)")
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }
	
	static func getCityWith(name: String, in country: String?) -> City? {
		let request: NSFetchRequest<City> = City.fetchRequest()
		let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
		
		let namePredicate = NSPredicate(format: "name == %@", name)
		if let country = country {
			let countryPredicate = NSPredicate(format: "country == %@", country)
			let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, countryPredicate])
			request.predicate = compoundPredicate
		} else {
			request.predicate = namePredicate
		}
		
		do {
			return try context.fetch(request).first
		} catch {
			print(error)
			return nil
		}
	}
    
	static func getCitiesWith(name: String, offset: Int) -> [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "name contains[cd] %@", name)
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        request.predicate = predicate
        request.fetchLimit = 20
        request.fetchOffset = offset
        
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
        
    }
    
    static func getFavoriteCities() -> [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "isFaved == true")
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
	
	
}
