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

    func testShouldReturnSameWhenFromEqualsToRoute() {
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

    func testShouldCreateNodeSet() {
        let nodeSet = CheapestRouteCalculator().createNodes(from: listConnection)

        XCTAssertNotNil(nodeSet)
        XCTAssertEqual(nodeSet.count, 7)
    }

    func testShouldCreateNodeConnections() {
        let nodeSet = CheapestRouteCalculator().createNodes(from: listConnection)

        CheapestRouteCalculator().createConnections(from: listConnection, nodes: nodeSet)

        XCTAssertNotNil(nodeSet)

        XCTAssertEqual(nodeSet.first { return $0.identifier == "New York"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.identifier == "Sydney"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.identifier == "Los Angeles"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.identifier == "Porto"}?.destinations.count, 0)
        XCTAssertEqual(nodeSet.first { return $0.identifier == "Tokyo"}?.destinations.count, 2)
        XCTAssertEqual(nodeSet.first { return $0.identifier == "Cape Town"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.identifier == "London"}?.destinations.count, 3)
    }
}
