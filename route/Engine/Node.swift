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
    var description: String
    lazy var destinations: [(Node, Int)] = []
    lazy var priceFromStart: Int = Int.max
    lazy var nodesFromStart: [Node] = []

    init(identifier: String, description: String) {
        self.identifier = identifier
        self.description = description
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
