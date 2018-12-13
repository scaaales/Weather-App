//
//  Weather+CoreDataProperties.swift
//  Weather App
//
//  Created by scales on 26.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var date: String?
    @NSManaged public var descr: String
    @NSManaged public var humidity: Double
    @NSManaged public var icon: String?
    @NSManaged public var maxTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var name: String?
    @NSManaged public var pressure: Double
    @NSManaged public var temp: Double
    @NSManaged public var windDegree: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var city: City?

}
