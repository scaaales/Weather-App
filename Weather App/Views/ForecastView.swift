//
//  ForecastView.swift
//  Weather App
//
//  Created by scales on 24.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//
import Foundation

protocol ForecastView: class {
    func handleForecast(_ forecast: [Weather])
}
