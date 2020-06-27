//
//  DoubleEntryRecord+CoreDataProperties.swift
//  
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import Foundation
import CoreData


extension DoubleEntryRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DoubleEntryRecord> {
        return NSFetchRequest<DoubleEntryRecord>(entityName: "DoubleEntryRecord")
    }

    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var associatedAsset: Asset?
    @NSManaged public var creditTransaction: Transaction?
    @NSManaged public var debitTransaction: Transaction?

}
