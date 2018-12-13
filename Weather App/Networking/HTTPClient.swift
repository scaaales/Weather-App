//
//  HTTPClient.swift
//  Weather App
//
//  Created by scales on 10.01.2018.
//  Copyright © 2018 kpi. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

protocol CustomError: Error {}

enum ErrorHTTP: String, CustomError {
    case noJSON = "Not containing JSON"
    
    var localizedDescription: String {
        return self.rawValue
    }
}

class HTTPClient {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func startLoad(forPath path: String, parameters: [String: Any]) -> Promise<[String: Any]> {
        let url = baseURL + path

        return firstly {
            Alamofire.request(url, parameters: parameters).responseJSON()
		}.then(on: .global()) { response -> Promise<[String: Any]> in
                guard let json = response.json as? [String: Any] else { throw(ErrorHTTP.noJSON) }
                return .value(json)
        }
    }
    
}


