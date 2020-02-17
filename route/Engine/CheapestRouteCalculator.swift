//
//  CheapestRouteCalculator.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol CheapestRouteCalculatorProtocol {

    func createNodes(from: ListConnection) -> Set<Node>

    func createConnections(from: ListConnection, nodes: Set<Node>)

    func calculateRoute(from: Node,
                        destination: Node,
                        nodes: Set<Node>) -> Node
}

struct CheapestRouteCalculator {

}

extension CheapestRouteCalculator: CheapestRouteCalculatorProtocol {

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

}
