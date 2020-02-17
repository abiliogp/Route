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
}
