//
//  ServiceErrorTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 20/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class ServiceErrorTest: XCTestCase {

    func testShouldHitCorrectErrorDescription() {
        XCTAssertEqual(ServiceError.unavailable.errorDescription,
                       "Sorry, try again later!")
        XCTAssertEqual(ServiceError.decodeError.errorDescription,
                       "Please, check your data and and try again!")
    }
}
