//
//  AssetTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Belyaev on 16.02.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import XCTest
import CoreData
@testable import Yawnvestments

class AssetTests: XCTestCase {

    private var context: NSManagedObjectContext!

    override func setUp() {
        let inMemoryContainer = NSPersistentContainer(name: "Yawnvestments")
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        inMemoryContainer.persistentStoreDescriptions = [persistentStoreDescription]
        inMemoryContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                XCTFail("Failed to create an in-memory persistent container: \(error), \(error.userInfo)")
            }
        })
        context = inMemoryContainer.viewContext
    }

    override func tearDown() {
        context = nil
    }

    func testShouldCalculateZeroQuantity() {
        let sut = Asset(context: context)
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 0.0)
    }

    func testShouldCalculatePositiveQuantity() {
        let sut = Asset(context: context)
        let quantities: [Decimal] = [5, 15, -2, -10, 30, -20]
        quantities.forEach { quantity in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            if quantity >= 0 {
                transaction.debitAsset = sut
                transaction.debitAmount = NSDecimalNumber(decimal: quantity)
            } else {
                transaction.creditAsset = sut
                transaction.creditAmount = NSDecimalNumber(decimal: -quantity)
            }
        }
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 18)
    }

    func testShouldCalculateNegativeQuantity() {
        let sut = Asset(context: context)
        let quantities: [Decimal] = [100, -200]
        quantities.forEach { quantity in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            if quantity >= 0 {
                transaction.debitAsset = sut
                transaction.debitAmount = NSDecimalNumber(decimal: quantity)
            } else {
                transaction.creditAsset = sut
                transaction.creditAmount = NSDecimalNumber(decimal: -quantity)
            }
        }
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, -100)
    }

}
