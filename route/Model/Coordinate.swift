//
//  Coordinate.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

struct Coordinate: Decodable {
    var from: LatLong
    var to: LatLong
}

struct LatLong: Decodable {
    var lat: Double
    var long: Double
}
