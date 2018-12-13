//
//  String.swift
//  Weather App
//
//  Created by scales on 01.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import Foundation

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
