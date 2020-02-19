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

    private var viewModel: RowTripViewModel?

    func setupView(viewModel: RowTripViewModel) {
        self.viewModel = viewModel
        self.setupBinding()
    }

    func setupBinding() {
        viewModel?.onTitleReady = {[weak self] (title) in
            guard let self = self else { return }
            self.descriptionLabel?.text = title
        }

        viewModel?.onPriceReady = {[weak self] (price) in
            guard let self = self else { return }
            debugPrint(price)
        }

        viewModel?.onStageImageReady = {[weak self] (image) in
            guard let self = self else { return }
            debugPrint(image)
        }
    }
}

extension TripViewCell {
    static let nibName = "TripCell"
    static let cellIdentifier =  "TRIP_CELL"
}
