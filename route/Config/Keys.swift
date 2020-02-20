//
//  Keys.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

public struct Keys {
    struct Plist {
        static let baseUrl = "BASE_URL"
    }

    struct RouteViewController {
        static let placeholderFrom = "FROM"
        static let placeholderTo = "TO"
        static let buttonGo = "GO"
    }

    struct EngineError {
        static let emptyList = "EMPTY_LIST"
        static let notValidFrom = "NOT_VALID_FROM"
        static let notValidTo = "NOT_VALID_TO"
        static let notReacheable = "NOT_REACHEABLE"
        static let sameFromAndTo = "SAME_FROM_AND_TO"
    }

    struct ServiceError {
        static let unavailabel = "UNAVAILABLE"
        static let decodeError = "DECODE_ERROR"
    }
}
