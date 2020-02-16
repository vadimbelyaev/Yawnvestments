//
//  PortfolioCell.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 17.02.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import UIKit

class PortfolioCell: UITableViewCell {

    var model: PortfolioCellViewModelType? {
        didSet {
            configureWithModel()
        }
    }

    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var returnRateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        assetNameLabel.text = nil
        amountLabel.text = nil
        returnRateLabel.text = nil
    }

    private func configureWithModel() {
        guard let model = model else { return }
        assetNameLabel.text = model.assetName
        amountLabel.text = model.amountString
        returnRateLabel.text = model.returnRateString
        if model.isReturnRateNegative {
            returnRateLabel.textColor = .systemRed
        } else {
            returnRateLabel.textColor = .systemGreen
        }
    }
}
