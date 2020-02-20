//
//  EngineErrorTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 20/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class EngineErrorTest: XCTestCase {

    func testShouldHitCorrectErrorDescription() {
        XCTAssertEqual(EngineError.emptyNodeList.errorDescription,
                       "Node list not ready yet!")
        XCTAssertEqual(EngineError.notReachable.errorDescription,
                       "Sorry, Not reacheable destination!")
        XCTAssertEqual(EngineError.notValidFrom.errorDescription,
                       "Please, select another from!")
        XCTAssertEqual(EngineError.notValidTo.errorDescription,
                       "Please, select another to!")
        XCTAssertEqual(EngineError.sameFromAndTo.errorDescription,
                       "Same from and to!")
    }
}
