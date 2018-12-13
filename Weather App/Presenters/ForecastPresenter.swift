//
//  ForecastPresenter.swift
//  Weather App
//
//  Created by scales on 01.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import PromiseKit

class ForecastPresenter {
	
    private weak var forecastView: ForecastView?
    private let openWeatherService = OpenWeatherService()

    func attachView(view: ForecastView) {
        forecastView = view
    }
    
    func detachForecastView() {
        forecastView = nil
    }
    
    func getForecast(for city: City) {
        loadForecast(for: city)
    }
    
    private func loadForecast(for city: City) {
        firstly {
            openWeatherService.loadForecast(forCityId: city.id)
        }.done { [weak self] forecast in
            city.replaceForecast(with: forecast)
            CoreDataManager.sharedInstance.saveContext()
            self?.forecastView?.handleForecast(forecast)
        }.catch { [weak self] error in
            print(error.localizedDescription)
            if city.forecastDate != nil {
                guard var oldForecast = city.forecast?.array as? [Weather] else { return }
                oldForecast = oldForecast.filter { $0.date != nil }
                self?.forecastView?.handleForecast(oldForecast)
            }
        }
    }
    
}
