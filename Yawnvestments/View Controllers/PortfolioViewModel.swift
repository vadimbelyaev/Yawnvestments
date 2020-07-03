//
//  PortfolioViewModel.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 16.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation

protocol PortfolioViewModelType {
    var numberOfSections: Int { get }
    var numberOfRowsInSection: Int { get }
    func cellViewModel(at indexPath: IndexPath) -> PortfolioCellViewModelType?
}

class PortfolioViewModel: PortfolioViewModelType {
    private weak var view: PortfolioViewControllerType?
    private var assetService: AssetServiceType

    init(view: PortfolioViewControllerType, assetService: AssetServiceType) {
        self.view = view
        self.assetService = assetService
    }

    var numberOfSections: Int {
        return 1
    }

    var numberOfRowsInSection: Int {
        return assetService.numberOfAssets
    }

    func cellViewModel(at indexPath: IndexPath) -> PortfolioCellViewModelType? {
        guard indexPath.section == 0, let asset = assetService.asset(at: indexPath.row) else {
            return nil
        }

        let quantityFormatter = NumberFormatter()
        quantityFormatter.numberStyle = .decimal
        let formattedQuantity = "" //quantityFormatter.string(from: NSDecimalNumber(decimal: asset.currentAmount?.decimalValue ?? 0)) ?? ""

        let randomReturnRate = Double.random(in: -2.0...2.0) // TODO: Replace random return rate with the actual implementation
        let returnRateFormatter = NumberFormatter()
        returnRateFormatter.numberStyle = .percent
        returnRateFormatter.minimumFractionDigits = 2
        returnRateFormatter.maximumFractionDigits = 2
        let formattedReturnRate = returnRateFormatter.string(from: NSNumber(value: randomReturnRate)) ?? ""

        return PortfolioCellViewModel(
            assetName: asset.displayName ?? "",
            amountString: formattedQuantity,
            returnRateString: formattedReturnRate,
            isReturnRateNegative: randomReturnRate < 0
        )
    }
}
