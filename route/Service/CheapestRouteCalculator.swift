//
//  CheapestRouteCalculator.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

protocol CheapestRouteCalculatorProtocol {
    
    func calculate(connections: ListConnection,
                   fromCity: Connection,
                   toCity: Connection) -> [Connection]
    
    func createNodes(from: ListConnection) -> Set<Node>

    func createConnections(from: ListConnection, nodes: Set<Node>)
}

struct CheapestRouteCalculator {

}

extension CheapestRouteCalculator: CheapestRouteCalculatorProtocol {

    func createNodes(from: ListConnection) -> Set<Node> {
        var nodeSet = Set<Node>()
        from.connections.forEach { (connection) in
            nodeSet.insert(Node(identifier: connection.from))
            nodeSet.insert(Node(identifier: connection.to))
        }
        return nodeSet
    }

    func createConnections(from: ListConnection, nodes: Set<Node>) {
        from.connections.forEach { (connection) in
            var currentNode = nodes.first { (node) -> Bool in
                return node.identifier == connection.from
            }
            nodes.filter { (node) -> Bool in
                if node.identifier == connection.to{
                    currentNode?.addNeighbors(node: node, price: connection.price)
                }
                return node.identifier == connection.to
            }
            
        }
    }
    


    func calculate(connections: ListConnection,
                   fromCity: Connection,
                   toCity: Connection) -> [Connection] {

        if fromCity == toCity {
            return [fromCity]
        }

        return [fromCity]
    }

}
