//
//  RouteViewModel.swift
//  route
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

class RouteViewModel {

    var onLoading: ((Bool) -> Void)?

    var onServiceError: ((ServiceError) -> Void)?

    var onAllNodes: ((Set<Node>) -> Void)?

    var onFromNodes: ((Set<Node>) -> Void)?

    var onGetRoute: (([Trip]) -> Void)?

    var onEngineError: ((EngineError) -> Void)?

    private var service: ServiceRouteProtocol
    private var routeCalculator: CheapestRouteCalculator

    init(service: ServiceRouteProtocol = Service.shared,
         routeCalculator: CheapestRouteCalculator = CheapestRouteCalculator.shared) {
        self.service = service
        self.routeCalculator = routeCalculator
    }

    func setupController() {
        self.onLoading?(true)
        self.service.fetchRoutes { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let listConnection):
                self.routeCalculator.setupNodes(from: listConnection)
                self.onAllNodes?(self.routeCalculator.nodes)
                self.onFromNodes?(self.routeCalculator.fromNodes)
                self.onLoading?(false)
            case .failure(let error):
                self.onServiceError?(error)
                self.onLoading?(false)
            }
        }
    }

    func findRoute(from: String, destination: String) {
        self.onLoading?(true)
        self.routeCalculator
            .calculateRoute(from: from,
                            destination: destination) { [weak self] (result) in

            guard let self = self else {
                return
            }

            switch result {
            case .success(let node):
                var tripList = [Trip]()
                tripList.append(Trip(description: node.description,
                                     stage: .arrive,
                                     price: node.priceFromStart))

                var currentNode = node
                while let lastNode = currentNode.nodeFromStart {
                    currentNode = lastNode
                    if lastNode.nodeFromStart == nil {
                        tripList.append(Trip(description: lastNode.description,
                                             stage: .departure,
                                             price: lastNode.priceFromStart))
                    } else {
                        tripList.append(Trip(description: lastNode.description,
                                             stage: .connection,
                                             price: lastNode.priceFromStart))
                    }
                }
                tripList.reverse()
                self.onGetRoute?(tripList)
                
            case .failure(let error):
                self.onEngineError?(error)
            }
            self.onLoading?(false)
        }
    }
}
