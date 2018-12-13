//
//  WeatherDetailsView.swift
//  Weather App
//
//  Created by scales on 25.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

class WeatherDetailsView: UIView {

    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.alpha = 0
            backButton.layer.cornerRadius = 3
        }
    }
    
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    
    func configure(for weather: Weather?, descriptionText: NSAttributedString) {
        guard let weather = weather else {
            descriptionTxtView.text = "Error loading weather"
            tempLbl.text = "😢"
            return
        }
        iconImg.kf.setImage(with: weather.iconURL)
        tempLbl.text = """
        Mid \(getTempString(from: weather.temp))
        Min \(getTempString(from: weather.minTemp))
        Max \(getTempString(from: weather.maxTemp))
        """
        descriptionTxtView.attributedText = descriptionText
        descriptionTxtView.textColor = .white
        timeLbl.text = weather.date == nil ? "Current" : "\(weather.formatedDate) \(weather.formatedTime)"
        
    }
    
    func showSubviews() {
        subviews.forEach { $0.isHidden = false }
    }
    
}
