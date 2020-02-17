//
//  Trip.swift
//  route
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

enum StageOptions {
    case departure
    case connection
    case arrive
}

struct Trip {
    var description: String
    var stage: StageOptions
    var price: Int
}
