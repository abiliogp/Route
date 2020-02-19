//
//  RowTripViewModel.swift
//  route
//
//  Created by Abilio Gambim Parada on 19/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation
import UIKit

class RowTripViewModel {

    var onTitleReady: ((String) -> Void)?

    var onPriceReady: ((String) -> Void)?

    var onStageImageReady: ((UIImage) -> Void)?

    private let trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }

    func setupViewCell() {

        self.onTitleReady?(trip.description)
        self.onPriceReady?("€ \(trip.price)")

        var image: UIImage?
        switch trip.stage {
        case .arrive:
            image = UIImage(named: ViewValues.Images.arrive)
        case .connection:
            image = UIImage(named: ViewValues.Images.connection)
        case .departure:
            image = UIImage(named: ViewValues.Images.departure)
        }

        if let image = image {
            self.onStageImageReady?(image)
        }
    }

}
