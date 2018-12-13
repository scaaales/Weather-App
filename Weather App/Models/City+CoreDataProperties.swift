//
//  City+CoreDataProperties.swift
//  
//
//  Created by Sergey Kletsov on 9/25/18.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var country: String
    @NSManaged public var forecastDate: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String
    @NSManaged public var weatherDate: NSDate?
    @NSManaged public var isFaved: Bool
    @NSManaged public var forecast: NSOrderedSet?

}

// MARK: Generated accessors for forecast
extension City {

    @objc(insertObject:inForecastAtIndex:)
    @NSManaged public func insertIntoForecast(_ value: Weather, at idx: Int)

    @objc(removeObjectFromForecastAtIndex:)
    @NSManaged public func removeFromForecast(at idx: Int)

    @objc(insertForecast:atIndexes:)
    @NSManaged public func insertIntoForecast(_ values: [Weather], at indexes: NSIndexSet)

    @objc(removeForecastAtIndexes:)
    @NSManaged public func removeFromForecast(at indexes: NSIndexSet)

    @objc(replaceObjectInForecastAtIndex:withObject:)
    @NSManaged public func replaceForecast(at idx: Int, with value: Weather)

    @objc(replaceForecastAtIndexes:withForecast:)
    @NSManaged public func replaceForecast(at indexes: NSIndexSet, with values: [Weather])

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: Weather)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: Weather)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSOrderedSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSOrderedSet)

}
