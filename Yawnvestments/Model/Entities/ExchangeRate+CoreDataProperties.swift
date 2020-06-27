//
//  ExchangeRate+CoreDataProperties.swift
//  
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import Foundation
import CoreData


extension ExchangeRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRate> {
        return NSFetchRequest<ExchangeRate>(entityName: "ExchangeRate")
    }

    @NSManaged public var currencyAmount: NSDecimalNumber?
    @NSManaged public var date: Date?
    @NSManaged public var asset: Asset?
    @NSManaged public var currency: Currency?

}
