//
//  ConvertDtoTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class ReadJsonTest: XCTestCase {

    func testShouldReadConnectionsList() throws {

        let listConnections = try ReadJson().loadDataFromFile(named: "connections",
                                              ofType: ".json",
                                              typeClass: ListConnection.self)

        XCTAssertNotNil(listConnections)
        XCTAssertNotNil(listConnections.connections)
        XCTAssertEqual(listConnections.connections.count, 9)
    }

}
