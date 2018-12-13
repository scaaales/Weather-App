//
//  CitiesResultsTableView.swift
//  Weather App
//
//  Created by scales on 19.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

protocol CitiesResultsTableView: class {
    func showCities(_ cities: [City])
    func addMoreCities(_ newCities: [City])
}
