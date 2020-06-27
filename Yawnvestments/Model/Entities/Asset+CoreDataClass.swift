//
//  Asset+CoreDataClass.swift
//
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import CoreData
import Foundation

public class Asset: NSManagedObject {
    public var currentQuantity: Decimal {
        var totalQuantity: Decimal = 0

        if let transactions = transactions as? Set<Transaction> {
            totalQuantity += transactions.reduce(0) {
                $0 + $1.amount.decimalValue
            }
        }

        return totalQuantity
    }
}
