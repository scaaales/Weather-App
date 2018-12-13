//
//  CityTableViewCell.swift
//  Weather App
//
//  Created by scales on 10.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit
import Kingfisher

class CityTableViewCell: UITableViewCell {

    static let reuseID = "CityTableViewCell"
    
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
	@IBOutlet private weak var updatedLabel: UILabel!
	
    func configure(for city: City) {
        guard let weather = city.currentWeather else {
            cityNameLabel.text = "Error loading weather for \(city.name)"
            return
        }
        self.cityNameLabel.text = "\(city.name), \(city.country)"
        self.tempLabel.text = "\(getTempString(from: weather.temp))"
        self.weatherImage.kf.setImage(with: weather.iconURL)
		
		if let lastUpd = city.weatherDate as Date? {
			self.updatedLabel.text = "Updated \(timeAgoSinceDate(lastUpd))"
			self.updatedLabel.isHidden = false
		} else {
			self.updatedLabel.isHidden = true
		}
    }
    
}
