//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by scales on 24.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit
import Kingfisher

class ForecastTableViewCell: UITableViewCell {

    static let reuseID = "ForecastTableViewCell"
    
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    func configure(for weather: Weather) {
        weatherImage.kf.setImage(with: weather.iconURL)
        timeLabel.text = weather.formatedTime
        detailLabel.text = """
        \(weather.descr.firstUppercased), temp \(getTempString(from: weather.temp))
        Wind is \(getWindDirectionString(from: weather.windDegree)), \(getWindSpeedString(from: weather.windSpeed))
        \(getHumidityString(from: weather.humidity).firstUppercased)
        \(getPressureString(from: weather.pressure).firstUppercased)
        """
    }
    
}
