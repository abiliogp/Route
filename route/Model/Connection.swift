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
