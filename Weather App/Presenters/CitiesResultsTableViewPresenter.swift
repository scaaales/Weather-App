//
//  CitiesResultsTableViewPresenter.swift
//  Weather App
//
//  Created by scales on 19.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//


class CitiesResultsTableViewPresenter {
    
    private weak var citiesResultsTableView: CitiesResultsTableView?
    private var fetchOffset = 0
    
    func attachView(view: CitiesResultsTableView) {
        citiesResultsTableView = view
    }
    
    func detachCityListView() {
        citiesResultsTableView = nil
    }
    
    func getCities(for searchText: String) {
        fetchOffset = 0
        let cities = CitiesCoreDataManager.getCitiesWith(name: searchText, offset: fetchOffset)
        citiesResultsTableView?.showCities(cities)
    }
    
    func getMoreCities(for searchText: String) {
        fetchOffset += 20
        let cities = CitiesCoreDataManager.getCitiesWith(name: searchText, offset: fetchOffset)
        citiesResultsTableView?.addMoreCities(cities)
    }
    
}

