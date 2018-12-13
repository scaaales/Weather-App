//
//  CityListPresenter.swift
//  Weather App
//
//  Created by scales on 12.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import PromiseKit

class CityListPresenter {
	private(set) var cities: [City] = []
	
    private weak var cityListView: CityListView?
    private let openWeatherService = OpenWeatherService()
	private var isShowingFavorite = false {
		didSet {
			cityListView?.isShowingFavorite = isShowingFavorite
		}
	}
	
    func attachView(view: CityListView) {
        cityListView = view
    }

    func detachCityListView() {
        cityListView = nil
    }

    func loadCities() -> [Promise<City>] {
		var citiesPromises = [Promise<City>]()
		for city in cities {
			let cityPromise = openWeatherService.loadWeather(forCityName: city.name, inCountry: city.country)
			citiesPromises.append(cityPromise)
		}
		
		return citiesPromises
    }
	
    func getFavoriteCities() {
        cities = CitiesCoreDataManager.getFavoriteCities()
		isShowingFavorite = true
		cityListView?.update()
		let citiesPromises = loadCities()
		when(fulfilled: citiesPromises)
			.done { [weak self] cities in
				self?.cities = cities
				self?.cityListView?.update()
			}.catch { error in
				print(error)
		}
    }
	
	func toggleCityFavoriteStatus(_ city: City) {
		city.isFaved.toggle()
		CoreDataManager.sharedInstance.saveContext()
		if !city.isFaved && isShowingFavorite {
			guard let cityIndex = cities.firstIndex(where: { city === $0 }) else { return }
			cities.remove(at: cityIndex)
			cityListView?.removeCityWithIndex(cityIndex)
		}
	}
	
	func getCity(with name: String) {
		let cityWithCountry = getCityWithCountry(from: name)
		let cityName = cityWithCountry.city
		let countryName = cityWithCountry.country
		
		if let existingCity = CitiesCoreDataManager.getCityWith(name: cityName, in: countryName) {
			cities = [existingCity]
		}
		isShowingFavorite = false
		openWeatherService.loadWeather(forCityName: cityName, inCountry: countryName)
			.done { [weak self] city in
				CoreDataManager.sharedInstance.saveContext()
				self?.cities = [city]
			}.ensure { [weak self] in
				self?.cityListView?.update()
			}
			.catch { [weak self] error in
				if error is CustomError {
					self?.cityListView?.showError()
				}
				print(error)
		}
	}
	
	func updateCities(completion: @escaping () -> Void) {
		let citiesPromises = loadCities()
		when(fulfilled: citiesPromises)
			.done { [weak self] cities in
				self?.cities = cities
			}.ensure { [weak self] in
				self?.cityListView?.update()
				completion()
			}
			.catch { error in
				print(error)
		}
	}
	
	private func getCityWithCountry(from string: String) -> (city: String, country: String?) {
		var cityName: String
		var countryName: String?
		
		let components = string.components(separatedBy: ",")
		if components.count == 2 {
			cityName = components[0].firstUppercased
			countryName = components[1].uppercased()
		} else {
			cityName = string.firstUppercased
		}
		
		return (city: cityName, country: countryName)
	}
	
}

