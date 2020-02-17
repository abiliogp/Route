//
//  TripViewCell.swift
//  route
//
//  Created by Abilio Gambim Parada on 17/02/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import UIKit

class TripViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel?

    func setupView(trip: Trip) {
        descriptionLabel?.text = "\(trip.description) <price \(trip.price)> <stage \(trip.stage)>"
    }

}
