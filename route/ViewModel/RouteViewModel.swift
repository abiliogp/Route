//
//  RouteViewModel.swift
//  route
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

class RouteViewModel {

    typealias TripSteps = Int

    var onLoading: ((Bool) -> Void)?

    var onServiceError: ((ServiceError) -> Void)?

    var onAllNodes: (([String]) -> Void)?

    var onFromNodes: (([String]) -> Void)?

    var onTripReady: ((TripSteps) -> Void)?

    var onEngineError: ((EngineError) -> Void)?

    private var service: ServiceRouteProtocol
    private var routeCalculator: CheapestRouteCalculator

    private lazy var rowViewModel: [RowTripViewModel] = []

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
                self.onAllNodes?(self.routeCalculator.nodes.map { $0.description })
                self.onFromNodes?(
                    self.routeCalculator.nodes.filter({ return !$0.destinations.isEmpty }).map({ $0.description })
                )
                self.onLoading?(false)
            case .failure(let error):
                self.onServiceError?(error)
                self.onLoading?(false)
            }
        }
    }

    private func setupRowViewModel(node: Node) {
        self.rowViewModel.removeAll()

        self.rowViewModel.append(RowTripViewModel(trip: Trip(description: node.description,
                                                             stage: .arrive,
                                                             price: node.priceFromStart)))

        var currentNode = node
        while let lastNode = currentNode.nodeFromStart {
            currentNode = lastNode
            if lastNode.nodeFromStart == nil {
                let trip = Trip(description: currentNode.description,
                                stage: .departure,
                                price: currentNode.priceFromStart)

                self.rowViewModel.append(RowTripViewModel(trip: trip))
            } else {
                let trip = Trip(description: currentNode.description,
                                stage: .connection,
                                price: currentNode.priceFromStart)

                self.rowViewModel.append(RowTripViewModel(trip: trip))
            }
        }

        self.rowViewModel.reverse()
    }
}

extension RouteViewModel {

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
                                        self.setupRowViewModel(node: node)
                                        self.onTripReady?(self.rowViewModel.count)
                                    case .failure(let error):
                                        self.onEngineError?(error)
                                }
                                self.onLoading?(false)
        }
    }

    func rowViewModel(for index: Int) -> RowTripViewModel {
        return self.rowViewModel[index]
    }
}
