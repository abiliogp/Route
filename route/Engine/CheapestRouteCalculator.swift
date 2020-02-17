//
//  CheapestRouteCalculator.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol CheapestRouteCalculatorProtocol {

    func setupNodes(from: ListConnection)

    func createNodes(from: ListConnection) -> Set<Node>

    func createConnections(from: ListConnection, nodes: Set<Node>)

    func calculateRoute(from: Node,
                        destination: Node,
                        nodes: Set<Node>) -> Node

    func calculateRoute(from: String,
                        destination: String,
                        completionHandler: @escaping (Result<Node, EngineError>) -> Void)
}

class CheapestRouteCalculator {

    static let shared = CheapestRouteCalculator()

    lazy var nodes = Set<Node>()

    var fromNodes: Set<Node> {
        return nodes.filter { (node) -> Bool in
            return node.destinations.isEmpty == false
        }
    }

    private init() {
    }
}

extension CheapestRouteCalculator: CheapestRouteCalculatorProtocol {

    func setupNodes(from: ListConnection) {
        self.nodes = createNodes(from: from)
        createConnections(from: from, nodes: nodes)
    }

    func createNodes(from: ListConnection) -> Set<Node> {
        var nodeSet = Set<Node>()
        from.connections.forEach { (connection) in
            nodeSet.insert(Node(identifier: connection.identifierFrom, description: connection.from))
            nodeSet.insert(Node(identifier: connection.identifierTo, description: connection.to))
        }
        return nodeSet
    }

    func createConnections(from: ListConnection, nodes: Set<Node>) {
        from.connections.forEach { (connection) in
            let currentNode = nodes.first { (node) -> Bool in
                return node.identifier == connection.identifierFrom
            }
            nodes.filter { (node) -> Bool in
                if node.identifier == connection.identifierTo {
                    currentNode?.addNeighbors(node: node, price: connection.price)
                }
                return node.identifier == connection.identifierTo
            }
        }
    }

    func calculateRoute(from: Node, destination: Node, nodes: Set<Node>) -> Node {

        if from.identifier == destination.identifier {
            return from
        }

        if from.destinations.isEmpty {
            return from
        }

        nodes.forEach { (node) in
            node.reset()
        }

        from.priceFromStart = 0

        var toBeVisited = Set([from])

        while !toBeVisited.isEmpty {

            guard let currentNode = toBeVisited.first(where: { (node) -> Bool in
                return node.visited == false
            }) else {
                return from
            }

            if currentNode.identifier == destination.identifier {
                debugPrint("destination: \(currentNode.description)")
                return currentNode
            }

            // Mark as visited
            currentNode.visited = true
            toBeVisited.remove(currentNode)

            debugPrint("Visited: \(currentNode.description)")

            for edged in currentNode.destinations {
                let nodeTo = edged.0
                let priceTo = edged.1

                toBeVisited.insert(nodeTo)

                let dist = currentNode.priceFromStart + priceTo
                if dist < nodeTo.priceFromStart {
                    nodeTo.priceFromStart = dist
                    nodeTo.nodeFromStart = currentNode
                }
            }
        }

        return from
    }


    func calculateRoute(from: String,
                        destination: String,
                        completionHandler: @escaping (Result<Node, EngineError>) -> Void) {

        if nodes.isEmpty {
            completionHandler(.failure(.emptyNodeList))
            return
        }

        if from.isEmpty {
            completionHandler(.failure(.notValidFrom))
            return
        }

        if destination.isEmpty {
            completionHandler(.failure(.notValidTo))
            return
        }

        if from == destination {
            completionHandler(.failure(.sameFromAndTo))
            return
        }

        guard let nodeFrom = nodes.first(where: { (node) -> Bool in
            return node.description == from
        }) else {
            completionHandler(.failure(.notValidFrom))
            return
        }

        guard let nodeTo = nodes.first(where: { (node) -> Bool in
            return node.description == destination
        }) else {
            completionHandler(.failure(.notValidTo))
            return
        }

        if nodeFrom == nodeTo {
            completionHandler(.failure(.sameFromAndTo))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                completionHandler(.failure(.notReachable))
                return
            }
            let destinationNode = self.calculateRoute(from: nodeFrom, destination: nodeTo, nodes: self.nodes)
            if destinationNode == nodeFrom {
                completionHandler(.failure(.notReachable))
            } else {
                completionHandler(.success(destinationNode))
            }
        }
    }
}
