//
//  CheapestRouteTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class CheapestRouteTest: XCTestCase {
    
    var listConnection: ListConnection!

    override func setUp() {
        do {
            self.listConnection = try ReadJson().loadDataFromFile(named: "connections",
                                                                   ofType: ".json",
                                                                   typeClass: ListConnection.self)
        } catch { }
    }

    func testShouldReturnSameWhenFromEqualsToRoute(){
        let fromCity = listConnection.connections.first!
        let toCity = fromCity

        let route = CheapestRouteCalculator().calculate(connections: listConnection,
                                                        fromCity: fromCity,
                                                        toCity: toCity)

        XCTAssertNotNil(route)
        XCTAssertEqual(route.count, 1)
    }

    func testShouldCalculateCheapestRoute() {
        let fromCity = listConnection.connections.first!
        let toCity = listConnection.connections.last!

        let route = CheapestRouteCalculator().calculate(connections: listConnection,
                                                        fromCity: fromCity,
                                                        toCity: toCity)

        XCTAssertNotNil(route)
    }
}
