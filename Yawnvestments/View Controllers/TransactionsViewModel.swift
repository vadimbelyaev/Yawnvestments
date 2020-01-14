//
//  TransactionsViewModel.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 07.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation

protocol TransactionsViewModelType: class {
    var numberOfSections: Int { get }
    var numberOfRowsInSection: Int { get }
    func cellViewModel(at indexPath: IndexPath) -> TransactionCellViewModelType?
}

class TransactionsViewModel: TransactionsViewModelType {

    private weak var view: TransactionsViewControllerType?
    private var transactionService: TransactionServiceType

    init(view: TransactionsViewControllerType, transactionService: TransactionServiceType) {
        self.view = view
        self.transactionService = transactionService
    }

    var numberOfSections: Int {
        return 1
    }

    var numberOfRowsInSection: Int {
        return transactionService.numberOfTransactions
    }

    func cellViewModel(at indexPath: IndexPath) -> TransactionCellViewModelType? {
        guard indexPath.section == 0, let transaction = transactionService.transaction(at: indexPath.row) else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        let mainNumberFormatter = NumberFormatter()
        mainNumberFormatter.numberStyle = .currency
        mainNumberFormatter.locale = Locale(identifier: "en_US")
        mainNumberFormatter.positivePrefix = "+" + mainNumberFormatter.positivePrefix
        mainNumberFormatter.minimumFractionDigits = 2
        mainNumberFormatter.maximumFractionDigits = 2

        let secondNumberFormatter = NumberFormatter()
        secondNumberFormatter.numberStyle = .none
        secondNumberFormatter.minimumFractionDigits = 0
        secondNumberFormatter.maximumFractionDigits = 0

        let displayAssetName = transaction.associatedAsset?.displayName ?? "N/A"
        let mainAmount: NSDecimalNumber?
        let isMainAmountNegative: Bool
        let secondAmount: NSDecimalNumber?
        let operation: String
        if transaction.associatedAsset == transaction.debitAsset {
            mainAmount = (transaction.creditAmount ?? 0).multiplying(by: -1)
            isMainAmountNegative = true
            secondAmount = transaction.debitAmount
            operation = "Buy: "
        } else {
            mainAmount = transaction.debitAmount
            isMainAmountNegative = false
            secondAmount = transaction.creditAmount
            operation = "Sell: "
        }

        return TransactionCellViewModel.init(
            dateAndAccountString: dateFormatter.string(from: transaction.date ?? Date()) + " – " + (transaction.debitAccount?.name ?? "N/A"),
            assetName: displayAssetName,
            amountString: mainNumberFormatter.string(from: mainAmount ?? 0) ?? "",
            isAmountNegative: isMainAmountNegative,
            summary: operation + (secondNumberFormatter.string(from: secondAmount ?? 0) ?? "")
        )
    }
}
