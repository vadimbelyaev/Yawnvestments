//
//  TransactionCell.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    var model: TransactionCellViewModelType? {
        didSet {
            configureWithModel()
        }
    }

    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateAndAccountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        assetNameLabel.text = nil
        summaryLabel.text = nil
        dateAndAccountLabel.text = nil
        amountLabel.text = nil
    }

    private func configureWithModel() {
        guard let model = model else { return }
        assetNameLabel.text = model.assetName
        summaryLabel.text = model.summary
        dateAndAccountLabel.text = model.dateString + " — " + model.accountName
        amountLabel.text = model.amountString
    }
}
