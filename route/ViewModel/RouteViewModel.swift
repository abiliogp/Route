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

    var service: ServiceRouteProtocol

    init(service: ServiceRouteProtocol = Service.shared) {
        self.service = service
    }

    func setupController() {
        self.onLoading?(true)
        self.service.fetchRoutes { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let listConnection):
                self.onLoading?(false)
            case .failure(let error):
                self.onServiceError?(error)
            }
        }
    }
}
