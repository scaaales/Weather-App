//
//  ViewController.swift
//  Weather App
//
//  Created by scales on 09.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {
	
    private let presenter = CityListPresenter()
    private var searchController: UISearchController!
    private lazy var resultTableViewController = CitiesResultsTableViewController()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        
        return refreshControl
    }()
    
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
	var isShowingFavorite: Bool = true {
		didSet {
			favoriteButton.isEnabled = !isShowingFavorite
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        presenter.attachView(view: self)
		presenter.getFavoriteCities()
    }
    
    private func setupTableView() {
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.addSubview(refreshControl)
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: resultTableViewController)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Enter city name here"
        searchController.searchBar.tintColor = .white
		searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        resultTableViewController.delegate = self
        
        favoriteButton.isEnabled = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        navigationController?.view.backgroundColor = #colorLiteral(red: 0.2413744628, green: 0.2497096062, blue: 0.5359306335, alpha: 1)
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let forecastVC = segue.destination as? ForecastViewController,
            let city = sender as? City else { return }
        
        forecastVC.city = city
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier == "segue" && sender is City 
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		presenter.updateCities {
			refreshControl.endRefreshing()
		}
    }
    
    func favoriteConfiguration(for indexPath: IndexPath) -> UIContextualAction {
        let city = presenter.cities[indexPath.row]
        let result = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, complition) in
			self?.presenter.toggleCityFavoriteStatus(city)
            complition(true)
            
            let ac = UIAlertController(title: nil, message: "\(city.name) was \(city.isFaved ? "saved to " : "deleted from ") favorite.", preferredStyle: .alert)
            self?.present(ac, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                ac.dismiss(animated: true)
            })
        }
        result.title = city.isFaved ? "Delete from favorite" : "Save to favorite"
        result.image = #imageLiteral(resourceName: "star")
        result.backgroundColor = city.isFaved ? .red : .green
        return result
    }
    
    @IBAction func favoriteTapped(_ sender: UIBarButtonItem) {
		presenter.getFavoriteCities()
    }
    
}

extension CityListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let city = presenter.cities[row]
        performSegue(withIdentifier: "segue", sender: city)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fav = favoriteConfiguration(for: indexPath)
        return UISwipeActionsConfiguration(actions: [fav])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [])
    }
    
}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseID, for: indexPath) as? CityTableViewCell,
            let city = presenter.cities[safe: indexPath.row] else {
            fatalError("cannot dequeue cell")
        }
        cell.configure(for: city)
        
        return cell
    }
}

extension CityListViewController: CityListView {
	func update() {
		cityTableView.alpha = 1
		cityTableView.reloadData()
	}
	
	func removeCityWithIndex(_ index: Int) {
		let indexPath = IndexPath(item: index, section: 0)
		cityTableView.deleteRows(at: [indexPath], with: .right)
	}
	
	func showError() {
		cityTableView.alpha = 0
	}
	
}

extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        resultTableViewController.searchText = searchController.searchBar.text
    }
}

extension CityListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text else { return }
		presenter.getCity(with: searchText)
		searchBar.resignFirstResponder()
		searchController.dismiss(animated: true)
	}
}

extension CityListViewController: CitiesResultsTableViewControllerDelegate {
	
    func didSelectCityWith(name: String) {
        searchController.dismiss(animated: true)
        presenter.getCity(with: name)
    }
    
}

