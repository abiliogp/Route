//
//  RouteTestSuite.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 19/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest

class RouteTestSuite: XCTestCase {

    override class var defaultTestSuite: XCTestSuite {
        let suite = XCTestSuite(forTestCaseClass: CheapestRouteTest.self)
        XCTestSuite(forTestCaseClass: NodeConnectionTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: RouteViewModelTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: ReadJsonTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: ServiceRouteTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: RowTripViewModelTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: EngineErrorTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: ServiceErrorTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: RouteViewModelMockedServerTest.self).tests.forEach { suite.addTest($0)}
        XCTestSuite(forTestCaseClass: RouteViewModelMockedEngineTest.self).tests.forEach { suite.addTest($0)}
        return suite
    }

    func testingStarts() {
        XCTAssert(true)
    }

}
