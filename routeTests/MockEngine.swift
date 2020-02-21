//
//  MockEngine.swift
//  routeTests
//
//  Created by Abilio Gambim Parada on 20/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
@testable import route

class MockEngine: CheapestRouteCalculatorProtocol {

    var forceErrorEngine: EngineError?

    var nodes: Set<Node> = []

    var fromNodes: Set<Node> = []

    func setupNodes(from: ListConnection) {
    }

    func createNodes(from: ListConnection) -> Set<Node> {
        return []
    }

    func createConnections(from: ListConnection, nodes: Set<Node>) {
    }

    func calculateRoute(from: Node, destination: Node, nodes: Set<Node>) -> Node {
        return Node(identifier: "", description: "London", lat: 0.0, long: 0.0)
    }

    func calculateRoute(from: String,
                        destination: String,
                        completionHandler: @escaping (Result<Node, EngineError>) -> Void) {

        if let forceErrorEngine = forceErrorEngine {
            completionHandler(.failure(forceErrorEngine))
        } else {
            completionHandler(.success(Node(identifier: "", description: "London", lat: 0.0, long: 0.0)))
        }
    }

    func clear() {
        forceErrorEngine = nil
    }

}
