//
//  Account+CoreDataProperties.swift
//
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import CoreData
import Foundation

extension Account {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var name: String
    @NSManaged public var note: String?
    @NSManaged public var transactions: NSSet?
}

// MARK: Generated accessors for transactions

extension Account {
    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)
}
