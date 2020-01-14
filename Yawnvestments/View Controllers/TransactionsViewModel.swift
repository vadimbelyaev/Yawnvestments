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
        dateFormatter.dateStyle = .short
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return TransactionCellViewModel.init(
            dateString: dateFormatter.string(from: transaction.date ?? Date()),
            assetName: transaction.debitAsset?.displayName ?? "NIL",
            accountName: transaction.debitAccount?.name ?? "NIL",
            amountString: numberFormatter.string(from: transaction.debitAmount ?? 0) ?? "-",
            isAmountNegative: (transaction.debitAmount ?? 0).decimalValue < 0,
            summary: "OMG WTF"
        )
    }
}
