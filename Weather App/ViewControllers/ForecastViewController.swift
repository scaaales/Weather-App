//
//  ForecastViewController.swift
//  Weather App
//
//  Created by scales on 23.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit
import Kingfisher

class ForecastViewController: UIViewController {
  
    @IBOutlet private weak var weatherDetailsView: WeatherDetailsView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    private weak var spinnerView: UIView?
    
    var city: City? {
        didSet {
            title = city?.name ?? "Loading..."
            if let city = city {
                presenter.getForecast(for: city)
            }
        }
    }
    
    private let presenter = ForecastPresenter()
    
    private var days = [[Weather]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView = displaySpinner()
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.attachView(view: self)
        
        if city != nil {
            setupCityView()
        }
    }
    
    private func displaySpinner() -> UIView {
        let spinnerView = UIView(frame: view.frame)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        view.subviews.forEach{ $0.isHidden = true }
        spinnerView.addSubview(ai)
        view.addSubview(spinnerView)
        
        return spinnerView
    }
    
    private func setupCityView() {
        guard let weather = city?.currentWeather else { return }
        weatherDetailsView.configure(for: weather, descriptionText: getDescription(for: weather))
    }
    
    private func getDescription(for weather: Weather?) -> NSAttributedString {
        let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let defaultAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        
        guard let weather = weather else { return NSAttributedString(string: "No description", attributes: defaultAttribute) }
    
        let result = NSMutableAttributedString(string: "\(weather.descr.firstUppercased)\n", attributes: boldAttribute)
        result.append(NSAttributedString(string: "Wind\n", attributes: boldAttribute))
        result.append(NSAttributedString(string: "\(getWindDirectionString(from: weather.windDegree))\n", attributes: defaultAttribute))
        result.append(NSAttributedString(string: "\(getWindSpeedString(from: weather.windSpeed).firstUppercased)\n", attributes: defaultAttribute))
        result.append(NSAttributedString(string: "Humidty\n", attributes: boldAttribute))
        result.append(NSAttributedString(string: "\(getHumidityString(from: weather.humidity, short: true))\n", attributes: defaultAttribute))
        result.append(NSAttributedString(string: "Atmospheric pressure\n", attributes: boldAttribute))
        result.append(NSAttributedString(string: "\(getPressureString(from: weather.pressure, short: true))\n", attributes: defaultAttribute))
        
        return result
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        tableView.reloadData()
        tableView.setInitialOffset()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let currentWeather = city?.currentWeather
        let currentDescription = getDescription(for: currentWeather)
        weatherDetailsView.configure(for: currentWeather, descriptionText: currentDescription)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.weatherDetailsView.backButton.alpha = 0
        }
    }
    
}

extension ForecastViewController: ForecastView {
    func handleForecast(_ forecast: [Weather]) {
        // get unique dates from forecast
        let dates = forecast.map { $0.formatedDate }.unique.sortedByDate()
		
        // get forecast seperated in days array
        dates.forEach { date in
            days.append(forecast.filter { $0.formatedDate == date })
        }
        
        let datesAndWeekdays = zip(dates, days).map { "\($0)\n\($1[0].weekday)" }
        
        segmentedControl.replaceSegments(segments: datesAndWeekdays)
        segmentedControl.makeMultiline(numberOfLines: 2)
        
        weatherDetailsView.showSubviews()
        view.subviews.forEach{ $0.isHidden = false }
        spinnerView?.removeFromSuperview()

        tableView.reloadData()
    }
}

extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeather = days[segmentedControl.selectedSegmentIndex][indexPath.row]
        let description = getDescription(for: selectedWeather)
        weatherDetailsView.configure(for: selectedWeather, descriptionText: description)
        if weatherDetailsView.backButton.alpha == 0 {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.weatherDetailsView.backButton.alpha = 1
            }
        }
    }
    
}

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex < days.count {
            return days[segmentedControl.selectedSegmentIndex].count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as! ForecastTableViewCell
        let weather = days[segmentedControl.selectedSegmentIndex][indexPath.row]
        cell.configure(for: weather)
        
        return cell
    }
}
