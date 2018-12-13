//
//  UIImage.swift
//  Weather App
//
//  Created by scales on 27.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: size.width, height: size.height)).image { _ in
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
