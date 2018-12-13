//
//  Extensiones.swift
//  Weather App
//
//  Created by scales on 23.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func replaceSegments(segments: [String]) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
        selectedSegmentIndex = 0
    }
    
    func makeMultiline(numberOfLines: Int) {
        subviews.forEach { segment in
            segment.subviews.filter { $0 is UILabel }.forEach {
                let label = $0 as? UILabel
                label?.numberOfLines = numberOfLines
            }
        }
    }
}
