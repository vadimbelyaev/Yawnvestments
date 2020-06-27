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
        sut.displayName = "Zero, Inc"
        sut.ticker = "ZERO"
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 0.0)
    }

    func testShouldCalculateZeroQuantityWithSomeTransactions() {
        let sut = Asset(context: context)
        sut.displayName = "Zero No Matter What, Inc"
        sut.ticker = "ZNMW"
        let account = Account(context: context)
        account.name = "My Brilliant Broker"

        // Quantities in 1/100th fractions of the value
        // (e.g. 220 is 2.2, -340 is -3.40)
        let quantitiesx100: [Int] = [220, -340, 100050, -1010, -66767, -2000, -30153, 0]
        quantitiesx100.forEach { quantityx100 in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            let decimalQuantity = Decimal.init(
                sign: quantityx100 >= 0 ? .plus : .minus,
                exponent: -2,
                significand: Decimal(abs(quantityx100))
            )
            transaction.amount = NSDecimalNumber(decimal: decimalQuantity)
        }
        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.currentQuantity, 0)
    }

    func testShouldCalculatePositiveQuantity() {
        let sut = Asset(context: context)
        sut.displayName = "Underground Labs X"
        sut.ticker = "UGLX"
        let account = Account(context: context)
        account.name = "Trustworthy"
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
        sut.displayName = "Bankrupt Brothers"
        sut.ticker = "CLOSED"
        let account = Account(context: context)
        account.name = "Worst Investment Consulting Group"
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
