//
//  TransactionCellViewModel.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation

protocol TransactionCellViewModelType {
    var dateString: String { get }
    var assetName: String { get }
    var accountName: String { get }
    var amountString: String { get }
    var isAmountNegative: Bool { get }
    var summary: String { get }
}

struct TransactionCellViewModel: TransactionCellViewModelType {
    let dateString: String
    let assetName: String
    let accountName: String
    let amountString: String
    let isAmountNegative: Bool
    let summary: String
}
