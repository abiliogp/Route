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
