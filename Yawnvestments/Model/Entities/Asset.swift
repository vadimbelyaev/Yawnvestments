//
//  Asset.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData

public class Asset: NSManagedObject {
    // Codegen by CoreData
}

extension Asset {
    public var currentQuantity: Decimal {
        var totalQuantity: Decimal = 0

        if let transactions = transactions as? Set<Transaction> {
            totalQuantity += transactions.reduce(0) {
                print("transactions.reduce; accumulated = \($0); addition = \($1.amount?.decimalValue)")
                return $0 + ($1.amount?.decimalValue ?? 0)
            }
        }

        return totalQuantity
    }
}
