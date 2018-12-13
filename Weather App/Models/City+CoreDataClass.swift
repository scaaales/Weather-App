//
//  City+CoreDataClass.swift
//  Weather App
//
//  Created by scales on 23.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//
//

import Foundation
import CoreData


public class City: NSManagedObject {

    var currentWeather: Weather? {
        return (forecast?.array as? [Weather])?.first { $0.date == nil }
    }
	
	var nameWithCountry: String {
		if !country.isEmpty {
			return "\(name),\(country)"
		} else {
			return name
		}
	}
    
    func replaceForecast(with forecast: [Weather]) {
        guard let currentWeather = currentWeather else { return }
        
        if let oldForecast = self.forecast {
            removeFromForecast(oldForecast)
        }
        
        let newArray = [currentWeather] + forecast
        let orderedSet = NSOrderedSet(array: newArray)
        addToForecast(orderedSet)
        forecastDate = NSDate()
    }
    
    func replaceCurrentWeather(with weather: Weather) {
        if let currentWeather = currentWeather {
            removeFromForecast(currentWeather)
        }
        addToForecast(weather)
        weatherDate = NSDate()
    }
	
	convenience init?(json: [String: Any]) {
		let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "City", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		let sys = json["sys"] as? [String: Any]
		guard let id = json["id"] as? Int64,
			let country = sys?["country"] as? String,
			let name = json["name"] as? String
			else {
				return nil
		}
		
		self.id = id
		self.name = name
		self.country = country
	}
    
}
