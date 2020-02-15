//
//  PortfolioCellViewModel.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.02.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation

protocol PortfolioCellViewModelType {
    var assetName: String { get }
    var amountString: String { get }
    var returnRateString: String { get }
    var isReturnRateNegative: Bool { get }
}

struct PortfolioCellViewModel: PortfolioCellViewModelType {
    let assetName: String
    let amountString: String
    let returnRateString: String
    let isReturnRateNegative: Bool
}
