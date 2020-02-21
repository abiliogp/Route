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

    var mapViewModel: MapTripViewModel?

    private var service: ServiceRouteProtocol
    private var routeCalculator: CheapestRouteCalculatorProtocol

    private lazy var rowViewModel: [RowTripViewModel] = []

    init(service: ServiceRouteProtocol = Service.shared,
         routeCalculator: CheapestRouteCalculatorProtocol = CheapestRouteCalculator.shared) {
        self.service = service
        self.routeCalculator = routeCalculator
    }

    func setupController() {
        self.onLoading?(true)
        self.service.fetchRoutes { [weak self] result in
            guard let self = self else { return }
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
            let stage: StageOptions = lastNode.nodeFromStart == nil ? .departure : .connection

            let trip = Trip(description: currentNode.description,
                            stage: stage,
                            price: currentNode.priceFromStart)

            self.rowViewModel.append(RowTripViewModel(trip: trip))
        }

        self.rowViewModel.reverse()
    }

    private func setupMapViewModel(node: Node) {

        var listMapTrip = [MapTrip]()

        listMapTrip.append(MapTrip(name: node.description,
                                   lat: node.lat,
                                   long: node.long))

        var currentNode = node
        while let lastNode = currentNode.nodeFromStart {
            currentNode = lastNode

            listMapTrip.append(MapTrip(name: currentNode.description,
                                       lat: currentNode.lat,
                                       long: currentNode.long))

        }

        listMapTrip.reverse()
        self.mapViewModel = MapTripViewModel(listMapTrip: listMapTrip)
    }
}

extension RouteViewModel {

    func findRoute(from: String, destination: String) {
        self.onLoading?(true)
        self.routeCalculator
            .calculateRoute(from: from,
                            destination: destination) { [weak self] (result) in

            guard let self = self else { return }

            switch result {
            case .success(let node):
                self.setupRowViewModel(node: node)
                self.setupMapViewModel(node: node)
                self.onTripReady?(self.rowViewModel.count)
            case .failure(let error):
                self.onEngineError?(error)
            }
            self.onLoading?(false)
        }
    }

    func rowViewModel(for index: Int) -> RowTripViewModel? {
        guard index < rowViewModel.count else { return nil }
        return self.rowViewModel[index]
    }

}
