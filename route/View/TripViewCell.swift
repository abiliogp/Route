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
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var imageStage: UIImageView?

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
            self.priceLabel?.text = price
        }

        viewModel?.onStageImageReady = {[weak self] (image) in
            guard let self = self else { return }
            self.imageStage?.image = image
        }
    }
}
