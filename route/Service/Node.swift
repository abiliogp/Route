//
//  Node.swift
//  route
//
//  Created by Abilio Gambim Parada on 15/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

class Node {
    var identifier: String
    var destinations: [(Node, Int)] = []
    var priceFromStart: Int = Int.max
    var nodesFromStart: [Node] = []
    
    init(identifier: String) {
        self.identifier = identifier
    }
}

extension Node {
    func addNeighbors(node: Node, price: Int) {
        destinations.append((node, price))
    }
}

extension Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
