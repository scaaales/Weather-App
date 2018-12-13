//
//  OpenWeatherService.swift
//  Weather App
//
//  Created by scales on 09.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit
import PromiseKit

enum ErrorService: String, CustomError {
    case cityParsing = "Cannot create city"
    case forecastParsing = "Cannot create forecast"
    
    var localizedDescription: String {
        return self.rawValue
    }
}

class OpenWeatherService {
    
    private let client = HTTPClient(baseURL: Constants.Config.baseURL)
	
	
	func loadWeather(forCityName name: String, inCountry country: String?, units: String? = nil, lang: String? = nil) -> Promise<City> {
		let path = getPath(for: WeatherType.weather.rawValue)
		let parameters = getParameters(forCityName: name, units: units, lang: lang)
		
		return firstly {
			client.startLoad(forPath: path, parameters: parameters)
		}.then { json -> Promise<City> in
			let city: City
			guard let id = json["id"] as? Int64 else { throw ErrorService.cityParsing }
			if let existingCity = CitiesCoreDataManager.getCityWith(id: id) {
				city = existingCity
				city.id = id
			} else if let existingCity = CitiesCoreDataManager.getCityWith(name: name, in: country) {
				city = existingCity
				city.id = id
			} else {
				guard let newCity = City(json: json) else { throw ErrorService.cityParsing }
				city = newCity
			}
			guard let weather = Weather(json: json) else { throw ErrorService.cityParsing }
			city.replaceCurrentWeather(with: weather)
			return .value(city)
		}
	}

    func loadForecast(forCityId id: Int64, units: String? = nil, lang: String? = nil) -> Promise<[Weather]> {
        let path = getPath(for: WeatherType.forecast.rawValue)
        let parameters = getParameters(forCityId: id, units: units, lang: lang)
		
        return firstly {
            client.startLoad(forPath: path, parameters: parameters)
		}.then(on: .global()) { json -> Promise<[Weather]> in
			guard let forecast = Weather.getForecast(from: json) else { throw ErrorService.forecastParsing }
			return .value(forecast)
        }
    }
	
    private func getPath(for weatherType: String) -> String {
        return Constants.Config.basePath + weatherType
    }
    
    private func getParameters(forCityId cityId: Int64, units: String?, lang: String?) -> [String: Any] {
        return ["id": cityId,
                "appId": Constants.Config.appid,
                "lang": lang ?? Lang.default.rawValue,
                "units": units ?? Units.default.rawValue]
    }
	
	private func getParameters(forCityName cityName: String, units: String?, lang: String?) -> [String: Any] {
		return ["q": cityName,
				"appId": Constants.Config.appid,
				"lang": lang ?? Lang.default.rawValue,
				"units": units ?? Units.default.rawValue]
	}
}
