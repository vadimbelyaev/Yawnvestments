//
//  Currency+CoreDataProperties.swift
//
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import CoreData
import Foundation

extension Currency {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var assetsRates: NSSet?
}

// MARK: Generated accessors for assetsRates

extension Currency {
    @objc(addAssetsRatesObject:)
    @NSManaged public func addToAssetsRates(_ value: ExchangeRate)

    @objc(removeAssetsRatesObject:)
    @NSManaged public func removeFromAssetsRates(_ value: ExchangeRate)

    @objc(addAssetsRates:)
    @NSManaged public func addToAssetsRates(_ values: NSSet)

    @objc(removeAssetsRates:)
    @NSManaged public func removeFromAssetsRates(_ values: NSSet)
}
