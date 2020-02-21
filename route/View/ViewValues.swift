//
//  ViewValues.swift
//  route
//
//  Created by Abilio Gambim Parada on 19/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import UIKit

public struct ViewValues {
    struct Tag {
        static let textFieldFrom = 0
        static let textFieldTo = 1
    }

    struct Images {
        static let arrive = "arrive"
        static let connection = "connection"
        static let departure = "departure"
    }

    struct Table {
        static let heightForRowTrip: CGFloat = 100
        static let segueIdentifier = "SHOW_MAP"
    }

    struct TripViewCell {
        static let nibName = "TripCell"
        static let cellIdentifier =  "TRIP_CELL"
    }

}
