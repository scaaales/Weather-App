//
//  UITableView.swift
//  Weather App
//
//  Created by scales on 20.02.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit

extension UITableView {
    func setInitialOffset() {
        guard self.numberOfSections > 0, self.numberOfRows(inSection: 0) > 0 else { return }
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
    }
}
