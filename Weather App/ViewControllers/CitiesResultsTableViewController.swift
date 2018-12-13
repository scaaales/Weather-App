//
//  CitiesResultsTableViewController.swift
//  Weather App
//
//  Created by scales on 19.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

protocol CitiesResultsTableViewControllerDelegate {
	func didSelectCityWith(name: String)
}

class CitiesResultsTableViewController: UITableViewController {
	
	private var cities = [City]()
	private let reuseID = "ResultCell"
	private let presenter = CitiesResultsTableViewPresenter()
	var delegate: CitiesResultsTableViewControllerDelegate?
	
	private var searchText: String? {
		didSet {
			guard let newText = searchText?.trimmingCharacters(in: .whitespaces), !newText.isEmpty, newText != oldValue else {
				return
			}
			presenter.getCities(for: newText)
		}
	}
	
	private var tableIsFull = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.attachView(view: self)
		view.alpha = 0.8
		view.backgroundColor = .black
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard let searchText = searchText else { return }
		presenter.getCities(for: searchText)
	}
}

// MARK: - TableViewDataSource
extension CitiesResultsTableViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: reuseID)
		let city = cities[indexPath.row]
		
		if let lastUpd = city.weatherDate as Date? {
			cell.detailTextLabel?.text = timeAgoSinceDate(lastUpd)
			cell.detailTextLabel?.textColor = .white
		}
		cell.textLabel?.text = "\(city.name), \(city.country)"
		cell.textLabel?.textColor = .white
		cell.backgroundColor = .clear
		
		return cell
	}
	
}

// MARK: - TableViewDelegate
extension CitiesResultsTableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let city = cities[indexPath.row]
		delegate?.didSelectCityWith(name: city.nameWithCountry)
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row + 1 == cities.count && !tableIsFull {
			guard let text = searchText?.trimmingCharacters(in: .whitespaces), !text.isEmpty else { return }
			presenter.getMoreCities(for: text)
		}
	}

}

extension CitiesResultsTableViewController: CitiesResultsTableView {
	func showCities(_ cities: [City]) {
		self.cities = cities
		tableIsFull = false
		tableView.reloadData()
		tableView.setInitialOffset()
	}
	
	func addMoreCities(_ newCities: [City]) {
		if newCities.isEmpty {
			tableIsFull = true
			return
		} else if cities.contains(newCities[0]) {
			tableIsFull = true
			return
		}
		cities += newCities
		tableView.reloadData()
	}
	
}
