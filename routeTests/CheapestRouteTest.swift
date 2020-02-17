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
    var nodeSet: Set<Node>!

    override func setUp() {
        do {
            self.listConnection = try ReadJson().loadDataFromFile(named: "connections",
                                                                  ofType: ".json",
                                                                  typeClass: ListConnection.self)

            self.nodeSet = CheapestRouteCalculator.shared.createNodes(from: listConnection)

            CheapestRouteCalculator.shared.createConnections(from: listConnection, nodes: nodeSet)
        } catch { }
    }

    func testShouldReturnSameWhenSameFromAndTo() {

        let nodeFrom = nodeSet.first { return $0.description ==  "New York" }!

        let destination = CheapestRouteCalculator.shared.calculateRoute(from: nodeFrom,
                                                                   destination: nodeFrom,
                                                                   nodes: nodeSet)

        XCTAssertNotNil(nodeFrom)
        XCTAssertEqual(destination, nodeFrom)
    }

    func testShouldCalculateCheapestRouteNewYorkToSydney() {
        let nodeFrom = nodeSet.first { return $0.description == "New York" }!
        let nodeTo = nodeSet.first { return $0.description == "Sydney" }!

        let destination = CheapestRouteCalculator.shared.calculateRoute(from: nodeFrom,
                                                                   destination: nodeTo,
                                                                   nodes: nodeSet)

        XCTAssertNotNil(destination)
        XCTAssertEqual(destination.description, "Sydney")
        XCTAssertEqual(destination.priceFromStart, 370)

        let lastNode = getLastNode(node: destination)
        XCTAssertNotNil(lastNode)
        XCTAssertEqual(lastNode?.description, "New York")
    }

    func testShouldCalculateCheapestRouteLondonToCapeTown() {
        let nodeFrom = nodeSet.first { return $0.description == "London" }!
        let nodeTo = nodeSet.first { return $0.description == "Cape Town" }!

        let destination = CheapestRouteCalculator.shared.calculateRoute(from: nodeFrom,
                                                                   destination: nodeTo,
                                                                   nodes: nodeSet)

        XCTAssertNotNil(destination)
        XCTAssertEqual(destination.description, "Cape Town")
        XCTAssertEqual(destination.priceFromStart, 520)

        let lastNode = getLastNode(node: destination)
        XCTAssertNotNil(lastNode)
        XCTAssertEqual(lastNode?.description, "London")
    }

    func testShouldReturnSameWhenNoRoute() {
        let nodeFrom = nodeSet.first { return $0.description == "Porto"}!
        let nodeTo = nodeSet.first { return $0.description == "Cape Town" }!

        let destination = CheapestRouteCalculator.shared.calculateRoute(from: nodeFrom,
                                                                   destination: nodeTo,
                                                                   nodes: nodeSet)

        XCTAssertNotNil(destination)
        XCTAssertEqual(destination.description, "Porto")
        XCTAssertEqual(destination, nodeFrom)
        XCTAssert(destination.destinations.isEmpty)
    }
}

extension CheapestRouteTest {
    func getLastNode(node: Node) -> Node? {
        var lastNode = node.nodeFromStart
        while lastNode?.nodeFromStart != nil {
            lastNode = lastNode?.nodeFromStart
        }
        return lastNode
    }
}
