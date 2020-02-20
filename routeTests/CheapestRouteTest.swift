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

    func testShouldFailureWhenEmptyNodeList() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.nodes.removeAll()

        CheapestRouteCalculator.shared.calculateRoute(from: "Sydney", destination: "Porto") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.emptyNodeList)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldFailureWhenNotValidFrom() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "", destination: "Porto") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.notValidFrom)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldFailureWhenNotValidFromInNode() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "Sao Paulo", destination: "Lisboa") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.notValidFrom)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldFailureWhenNotValidToInNode() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "Porto", destination: "Lisboa") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.notValidTo)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldFailureWhenNotValidTo() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "Porto", destination: "") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.notValidTo)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldFailureWhenSameFromAndTo() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "Porto", destination: "Porto") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.sameFromAndTo)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldFailureWhenNotReachable() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "Porto", destination: "Tokyo") { (result) in
            switch result {
            case .success(let node):
                XCTAssertFalse(true)
            case .failure(let engineError):
                XCTAssertEqual(engineError, EngineError.notReachable)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
    }

    func testShouldSuccessWhenValidFromAndTo() {
        let expect = XCTestExpectation()

        CheapestRouteCalculator.shared.setupNodes(from: listConnection)

        CheapestRouteCalculator.shared.calculateRoute(from: "Tokyo", destination: "Porto") { (result) in
            switch result {
            case .success(let node):
                XCTAssertNotNil(node)
                XCTAssertEqual(node.description, "Porto")
            case .failure(let engineError):
                XCTAssertFalse(true)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5.0)
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
