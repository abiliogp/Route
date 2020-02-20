//
//  EngineError.swift
//  route
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

enum EngineError: Error {
    case emptyNodeList
    case notValidFrom
    case notValidTo
    case notReachable
    case sameFromAndTo
}

extension EngineError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .emptyNodeList:
        return NSLocalizedString(Keys.EngineError.emptyList, comment: "EMPTY_LIST")
        case .notValidFrom:
        return NSLocalizedString(Keys.EngineError.notValidFrom, comment: "NOT_VALID_FROM")
        case .notValidTo:
        return NSLocalizedString(Keys.EngineError.notValidTo, comment: "NOT_VALID_TO")
        case .notReachable:
        return NSLocalizedString(Keys.EngineError.notReacheable, comment: "NOT_REACHEABLE")
        case .sameFromAndTo:
        return NSLocalizedString(Keys.EngineError.sameFromAndTo, comment: "SAME_FROM_AND_TO")
        }
    }
}
