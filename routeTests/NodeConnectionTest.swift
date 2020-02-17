//
//  NodeConnectionTest.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 16/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import XCTest
@testable import route

class NodeConnectionTest: XCTestCase {

    var listConnection: ListConnection!

    override func setUp() {
        do {
            self.listConnection = try ReadJson().loadDataFromFile(named: "connections",
                                                                   ofType: ".json",
                                                                   typeClass: ListConnection.self)
        } catch { }
    }

    func testShouldCreateNodeSet() {
        let nodeSet = CheapestRouteCalculator.shared.createNodes(from: listConnection)

        XCTAssertNotNil(nodeSet)
        XCTAssertEqual(nodeSet.count, 7)
    }

    func testShouldCreateNodeConnections() {
        let nodeSet = CheapestRouteCalculator.shared.createNodes(from: listConnection)

        CheapestRouteCalculator.shared.createConnections(from: listConnection, nodes: nodeSet)

        XCTAssertNotNil(nodeSet)

        XCTAssertEqual(nodeSet.first { return $0.description == "New York"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.description == "Sydney"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.description == "Los Angeles"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.description == "Porto"}?.destinations.count, 0)
        XCTAssertEqual(nodeSet.first { return $0.description == "Tokyo"}?.destinations.count, 2)
        XCTAssertEqual(nodeSet.first { return $0.description == "Cape Town"}?.destinations.count, 1)
        XCTAssertEqual(nodeSet.first { return $0.description == "London"}?.destinations.count, 3)
    }

    func testShoudlGetSameIdentifierForSameLatLong() {
        let conNewYork = listConnection.connections.first { return $0.from == "New York"}!

        let newConNovaYork = Connection(from: "Nova York",
                                        to: conNewYork.to,
                                        coordinates: conNewYork.coordinates,
                                        price: conNewYork.price)
        let newConNovaYorkEUA = Connection(from: "Nova York - EUA",
                                        to: conNewYork.to,
                                        coordinates: conNewYork.coordinates,
                                        price: conNewYork.price)

        let newConNovaYorkUSA = Connection(from: "New York - USA",
                                        to: conNewYork.to,
                                        coordinates: conNewYork.coordinates,
                                        price: conNewYork.price)

        let newListConnections = ListConnection(connections: [conNewYork,
                                                              newConNovaYork,
                                                              newConNovaYorkEUA,
                                                              newConNovaYorkUSA])

        let nodeSet = CheapestRouteCalculator.shared.createNodes(from: newListConnections)

        // There are 2 nodes, New York and its destination Los Angeles
        XCTAssertEqual(nodeSet.count, 2)

        XCTAssertNotNil(nodeSet.first { return $0.description == "New York"})
        XCTAssertNotNil(nodeSet.first { return $0.description == "Los Angeles"})

        XCTAssertNil(nodeSet.first { return $0.description == "Nova York"})
        XCTAssertNil(nodeSet.first { return $0.description == "Nova York - EUA"})
        XCTAssertNil(nodeSet.first { return $0.description == "New York - USA"})
    }

    func testShouldReturnAllNodesFrom() {
        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        XCTAssertEqual(CheapestRouteCalculator.shared.fromNodes.count, 6)
    }
}
