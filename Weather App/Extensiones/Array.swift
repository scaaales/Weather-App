//
//  Array.swift
//  Weather App
//
//  Created by scales on 01.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

extension Array where Element == String {
    func sortedByDate() -> [String] {
        return self.sorted {
            let first = $0.components(separatedBy: ".") // [0] = day, [1] = month
            let second = $1.components(separatedBy: ".")
            let firstDay = first[0]
            let firstMonth = first[1]
            let secondDay = second[0]
            let secondMonth = second[1]
            if firstMonth == secondMonth {
                return firstDay < secondDay
            } else {
                return firstDay > secondDay
            }
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
