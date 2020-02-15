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
        return PortfolioCellViewModel(
            assetName: asset.displayName ?? "N/A",
            amountString: "1234.56",
            returnRateString: "12.34 %",
            isReturnRateNegative: false
        )
    }
}
