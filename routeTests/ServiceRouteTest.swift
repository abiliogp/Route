//
//  ServiceRouteTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class ServiceRouteTest: XCTestCase {

    func testShouldFetchDataFromServer() {
        let expect = XCTestExpectation()

        Service.shared.fetchRoutes { (result) in
            switch result {
            case .success(let listConnections):
                XCTAssertNotNil(listConnections)
                XCTAssertNotNil(listConnections.connections)
                XCTAssertEqual(listConnections.connections.count, 9)

            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }
}
