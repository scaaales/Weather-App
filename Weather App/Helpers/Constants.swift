//
//  Constants.swift
//  Weather App
//
//  Created by scales on 09.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import Foundation

enum Units: String {
    case imperial
    case `default` = "metric"
}

enum Lang: String {
    case russian = "ru"
    case ukrainian = "ua"
    case `default` = "en"
}

enum WeatherType: String {
    case weather
    case forecast
}

enum Constants {
    
    enum Config {
        static let basePath = "data/2.5/"
        static let baseURL = "http://api.openweathermap.org/"
        static let appid = "88bb8bbfce9cbb3e00ba6037e35b1287"
    }
    
    static let defaultParameters = ["units": Units.default.rawValue,
                             "lang": Lang.default.rawValue,
                             "appid": Constants.Config.appid]
    
}
