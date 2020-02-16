//
//  Connection.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

struct Connection: Decodable {
    var from: String
    var to: String
    var coordinates: Coordinate
    var price: Int
}

extension Connection {
    var identifierFrom: String {
        let lat = coordinates.from.lat
        let long = coordinates.from.long
        return "Lat\(lat):Long\(long)"
    }

    var identifierTo: String {
        let lat = coordinates.to.lat
        let long = coordinates.to.long
        return "Lat\(lat):Long\(long)"
    }
}
