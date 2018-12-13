//
//  Funcs.swift
//  Weather App
//
//  Created by scales on 26.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import Foundation


/// Function that return string to given temperature
///
/// - Parameter temp: type Double?; can be nil
/// - Returns: If temp is *nil* **"-"**, otherwise **"tempºC"**
func getTempString(from temp: Double?) -> String {
    guard let temp = temp else {
        return "-"
    }
    return "\(temp)ºC"
}

/// Function that return direction string to given wind degree
///
/// - Parameter degree: type Double?; can be nil
/// - Returns: If temp is *nil* **"no info about direction"**, otherwise **"direction"**
func getWindDirectionString(from degree: Double?) -> String {
    guard let degree = degree else {
        return "no info about direction"
    }
    let directions = ["North",
                      "North-Northeast",
                      "Northeast",
                      "East-Northeast",
                      "East",
                      "East-Southeast",
                      "Southeast",
                      "South-Southeast",
                      "South",
                      "South-Southwes",
                      "Southwest",
                      "West-Southwest",
                      "West",
                      "West-Northwest",
                      "Northwest",
                      "North-Northwest"]
    
    let i = Int((degree + 11.25)/22.5)
    return directions[i % 16]
}

/// Function that return string to given wind speed
///
/// - Parameter speed: type Double?; can be nil
/// - Returns: If temp is *nil* **"no info about speed"**, otherwise **"speed (speed) m/sec"**
func getWindSpeedString(from speed: Double?) -> String {
    guard let speed = speed else {
        return "no info about speed"
    }
    return "speed \(speed) m/sec"
}

/// Function that return string to given humidity
///
/// - Parameter humidity: type Double?; can be nil
/// - Parameter short: type Bool; if short == *true*, returning format will be short (only **"(humidity)%"** or **"no info"**)
/// - Returns: If temp is *nil* **"no info about humidity"**, otherwise **"humidity (humidity)%"**
func getHumidityString(from humidity: Double?, short: Bool = false) -> String {
    guard let humidity = humidity else {
        return short ? "no info" : "no info about humidity"
    }
    return short ? "\(humidity)%" : "humidity \(humidity)%"
}

/// Function that return string to given pressure
///
/// - Parameter pressure: type Double?; can be nil
/// - Parameter short: type Bool; if short == *true*, returning format will be short (only **"(pressure) hPa"** or **"no info"**)
/// - Returns: If temp is *nil* **"no info about atmospheric pressure"**, otherwise **"atmospheric pressure (pressure)hPa"**
func getPressureString(from pressure: Double?, short: Bool = false) -> String {
    guard let pressure = pressure else {
        return short ? "no info" : "no info about atmospheric pressure"
    }
    return short ? "\(pressure) hPa" : "atmospheric pressure \(pressure) hPa"
}


func timeAgoSinceDate(_ date:Date) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        return "Last year"
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        return "1 month ago"
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        return "1 week ago"
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        return "1 day ago"
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        return "1 hour ago"
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        return "1 minute ago"
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "just now"
    }
    
}

