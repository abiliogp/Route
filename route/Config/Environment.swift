//
//  Environment.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

public enum Environment {

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let baseUrl: String = {
        guard let baseUrl = Environment.infoDictionary[Keys.Plist.baseUrl] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return baseUrl
    }()
}
