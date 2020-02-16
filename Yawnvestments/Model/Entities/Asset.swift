//
//  Asset.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation
import CoreData

class Asset: NSManagedObject {
    //Codegen by CoreData

    public var currentQuantity: Decimal {
        var totalQuantity: Decimal = 0

        if let buyTransactions = buyTransactions as? Set<Transaction> {
            totalQuantity += buyTransactions.reduce(0, {
                $0 + ($1.debitAmount?.decimalValue ?? 0)
            })
        }

        if let sellTransactions = sellTransactions as? Set<Transaction> {
            totalQuantity -= sellTransactions.reduce(0, {
                $0 + ($1.creditAmount?.decimalValue ?? 0)
            })
        }

        return totalQuantity
    }
}
