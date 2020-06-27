//
//  AssetTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Belyaev on 16.02.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest
@testable import Yawnvestments

class AssetTests: XCTestCase {
    private var context: NSManagedObjectContext!

    override func setUp() {
        let inMemoryContainer = NSPersistentContainer(name: "Yawnvestments")
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        inMemoryContainer.persistentStoreDescriptions = [persistentStoreDescription]
        inMemoryContainer.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                XCTFail("Failed to create an in-memory persistent container: \(error), \(error.userInfo)")
            }
        })
        context = inMemoryContainer.viewContext
    }

    override func tearDown() {
        context = nil
    }

    func testShouldCalculateZeroQuantityWithNoTransactions() {
        let sut = Asset(context: context)
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 0.0)
    }

    func testShouldCalculateZeroQuantityWithSomeTransactions() {
        let sut = Asset(context: context)
        let account = Account(context: context)
        let quantities: [Decimal] = [2.2, -3.4, 1000.5, -10.1, -667.67, -20, -301.53, 0]
        quantities.forEach { quantity in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            transaction.amount = NSDecimalNumber(decimal: quantity)
        }
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 0)
    }

    func testShouldCalculatePositiveQuantity() {
        let sut = Asset(context: context)
        let account = Account(context: context)
        let quantities: [Decimal] = [5, 15, -2, -10, 30, -20]
        quantities.forEach { quantity in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            transaction.amount = NSDecimalNumber(decimal: quantity)
        }
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 18)
    }

    func testShouldCalculateNegativeQuantity() {
        let sut = Asset(context: context)
        let account = Account(context: context)
        let quantities: [Decimal] = [100, -200]
        quantities.forEach { quantity in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            transaction.amount = NSDecimalNumber(decimal: quantity)
        }
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, -100)
    }
}
