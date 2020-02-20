//
//  ServiceError.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case unavailable
    case decodeError
}

extension ServiceError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .unavailable:
        return NSLocalizedString(Keys.ServiceError.unavailabel, comment: "UNAVAILABLE")
        case .decodeError:
        return NSLocalizedString(Keys.ServiceError.decodeError, comment: "DECODE_ERROR")
        }
    }
}
