//
//  Weather+CoreDataClass.swift
//  Weather App
//
//  Created by scales on 23.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//
//

import Foundation
import CoreData


public class Weather: NSManagedObject {

    var iconURL: URL? {
        if let icon = icon {
            return URL(string: "http://openweathermap.org/img/w/" + icon + ".png")
        } else {
            return URL(string: "https://cdn4.iconfinder.com/data/icons/ui-beast-4/32/Ui-12-512.png")
        }
    }
    
    var formatedTime: String {
        guard let result = date?.components(separatedBy: " ").last?.dropLast(3) else { return "--:--" }
        return String(result)
    }
    
    /// Date in format **"day.month"**
    var formatedDate: String {
        // date format "2014-07-23 09:00:00"
        let errorDate = "--.--"
        guard let dateSeperated = date?.components(separatedBy: " ").first?.components(separatedBy: "-") else { return errorDate }
        if dateSeperated.count != 3 {
            return errorDate
        }
        
        return "\(dateSeperated[2]).\(dateSeperated[1])"
        
    }
    
    var weekday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let dateString = self.date?.components(separatedBy: " ").first,
            let date = dateFormatter.date(from: dateString) else { return "--" }
        
        dateFormatter.dateFormat = "EEE"
        
        return dateFormatter.string(from: date)
    }
    
    convenience init?(json: [String: Any]) {
		let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context) else { return nil }
        
        self.init(entity: entity, insertInto: context)
        
        let weather = (json["weather"] as? [[String: Any]])?.first
		let extractedExpr: [String : Double]? = json["main"] as? [String: Double]
		let main = extractedExpr
        let wind = json["wind"] as? [String: Double]
        let speed = wind?["speed"]
        let deg = wind?["deg"]
        
        guard let desсr = weather?["description"] as? String,
            let temp = main?["temp"] else {
                return nil
        }
        
        self.descr = desсr
        self.temp = temp
        self.windSpeed = speed ?? 0
        self.windDegree = deg ?? 0
        
        name = weather?["main"] as? String
        icon = weather?["icon"] as? String
        pressure = main?["pressure"] ?? 0
        humidity = main?["humidity"] ?? 0
        minTemp = main?["temp_min"] ?? 0
        maxTemp = main?["temp_max"] ?? 0
        date = json["dt_txt"] as? String // for forecast
    }
    
    static func getForecast(from json: [String: Any]) -> [Weather]? {
        guard let list = json["list"] as? [[String: Any]] else {
            print("list type wrong or list doesnt exist")
            return nil
        }
        
        return list.compactMap { Weather(json: $0) }
    }
    
}
