//
//  MapTripViewModel.swift
//  route
//
//  Created by Abilio Gambim Parada on 21/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

class MapTripViewModel {

    var onMapReady: (([MapTrip]) -> Void)?

    private let listMapTrip: [MapTrip]

    init(listMapTrip: [MapTrip]) {
        self.listMapTrip = listMapTrip
    }

    func setupController() {
        self.onMapReady?(listMapTrip)
    }
}
