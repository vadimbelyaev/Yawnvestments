//
//  Asset+CoreDataProperties.swift
//
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import CoreData
import Foundation

extension Asset {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asset> {
        return NSFetchRequest<Asset>(entityName: "Asset")
    }

    @NSManaged public var displayName: String
    @NSManaged public var note: String?
    @NSManaged public var ticker: String
    @NSManaged public var associatedDoubleEntryRecords: NSSet?
    @NSManaged public var exchangeRates: NSSet?
    @NSManaged public var transactions: NSSet?
}

// MARK: Generated accessors for associatedDoubleEntryRecords

extension Asset {
    @objc(addAssociatedDoubleEntryRecordsObject:)
    @NSManaged public func addToAssociatedDoubleEntryRecords(_ value: DoubleEntryRecord)

    @objc(removeAssociatedDoubleEntryRecordsObject:)
    @NSManaged public func removeFromAssociatedDoubleEntryRecords(_ value: DoubleEntryRecord)

    @objc(addAssociatedDoubleEntryRecords:)
    @NSManaged public func addToAssociatedDoubleEntryRecords(_ values: NSSet)

    @objc(removeAssociatedDoubleEntryRecords:)
    @NSManaged public func removeFromAssociatedDoubleEntryRecords(_ values: NSSet)
}

// MARK: Generated accessors for exchangeRates

extension Asset {
    @objc(addExchangeRatesObject:)
    @NSManaged public func addToExchangeRates(_ value: ExchangeRate)

    @objc(removeExchangeRatesObject:)
    @NSManaged public func removeFromExchangeRates(_ value: ExchangeRate)

    @objc(addExchangeRates:)
    @NSManaged public func addToExchangeRates(_ values: NSSet)

    @objc(removeExchangeRates:)
    @NSManaged public func removeFromExchangeRates(_ values: NSSet)
}

// MARK: Generated accessors for transactions

extension Asset {
    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)
}
