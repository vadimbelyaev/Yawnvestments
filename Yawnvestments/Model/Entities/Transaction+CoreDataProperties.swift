//
//  Transaction+CoreDataProperties.swift
//
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import CoreData
import Foundation

extension Transaction {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var account: Account
    @NSManaged public var asset: Asset
    @NSManaged public var doubleEntryRecordsCredit: NSSet?
    @NSManaged public var doubleEntryRecordsDebit: NSSet?
}
