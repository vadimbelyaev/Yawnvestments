//
//  Stock+CoreDataProperties.swift
//  
//
//  Created by Vadim Belyaev on 6/27/20.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }


}
