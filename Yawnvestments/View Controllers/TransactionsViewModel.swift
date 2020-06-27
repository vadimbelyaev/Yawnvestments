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
    private var doubleEntryRecordService: DoubleEntryRecordServiceType

    init(view: TransactionsViewControllerType, doubleEntryRecordService: DoubleEntryRecordServiceType) {
        self.view = view
        self.doubleEntryRecordService = doubleEntryRecordService
    }

    var numberOfSections: Int {
        return 1
    }

    var numberOfRowsInSection: Int {
        return doubleEntryRecordService.numberOfRecords
    }

    func cellViewModel(at indexPath: IndexPath) -> TransactionCellViewModelType? {
        guard indexPath.section == 0, let record = doubleEntryRecordService.record(at: indexPath.row) else {
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

        let displayAssetName = record.associatedAsset?.displayName ?? "N/A"
        let mainAmount: NSDecimalNumber?
        let isMainAmountNegative: Bool
        let secondAmount: NSDecimalNumber?
        let operation: String
        if record.associatedAsset == record.debitTransaction?.asset {
            mainAmount = record.creditTransaction?.amount ?? 0
            isMainAmountNegative = true
            secondAmount = record.debitTransaction?.amount ?? 0
            operation = "Buy: "
        } else {
            mainAmount = record.debitTransaction?.amount ?? 0
            isMainAmountNegative = false
            secondAmount = record.creditTransaction?.amount ?? 0
            operation = "Sell: "
        }

        return TransactionCellViewModel.init(
            dateAndAccountString: dateFormatter.string(from: record.date ?? Date()) + " – " + (record.debitTransaction?.account?.name ?? "N/A"),
            assetName: displayAssetName,
            amountString: mainNumberFormatter.string(from: mainAmount ?? 0) ?? "",
            isAmountNegative: isMainAmountNegative,
            summary: operation + (secondNumberFormatter.string(from: secondAmount ?? 0) ?? "")
        )
    }
}
