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

//    var description: String
//    var stage: StageOptions
//    var price: Int

    var onTitleReady: ((String) -> Void)?

    var onPriceReady: ((String) -> Void)?

    var onStageImageReady: ((UIImage) -> Void)?

    private let trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }

    func setupViewCell(){

        self.onTitleReady?(trip.description)
        self.onPriceReady?("€ \(trip.price)")

        switch trip.stage {
            case .arrive:
                self.onStageImageReady?(UIImage())
            case .connection:
                self.onStageImageReady?(UIImage())
            case .departure:
                self.onStageImageReady?(UIImage())
        }

    }
    

}
