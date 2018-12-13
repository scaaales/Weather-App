//
//  CityListView.swift
//  Weather App
//
//  Created by scales on 12.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

protocol CityListView: class {
	var isShowingFavorite: Bool { set get }
    func update()
	func removeCityWithIndex(_ index: Int)
	func showError()
}
