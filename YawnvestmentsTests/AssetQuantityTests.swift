//
//  AssetQuantityTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Belyaev on 16.02.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest
@testable import Yawnvestments

class AssetQuantityTests: CoreDataXCTestCase {
    func testShouldCalculateZeroQuantityWithNoTransactions() {
        let sut = Asset(context: context)
        sut.displayName = "Zero, Inc"
        sut.ticker = "ZERO"
        XCTAssertNoThrow(try context.save())
        context.refresh(sut, mergeChanges: false)
        XCTAssertEqual(sut.currentAmount, 0)
    }

    func testShouldCalculateZeroQuantityWithSomeTransactions() {
        let sut = Asset(context: context)
        sut.displayName = "Zero No Matter What, Inc"
        sut.ticker = "ZNMW"
        let account = Account(context: context)
        account.name = "My Brilliant Broker"

        let amounts: [Int64] = [220, -340, 100050, -1010, -66767, -2000, -30153, 0]
        amounts.forEach { amount in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            transaction.amount = amount
        }
        XCTAssertNoThrow(try context.save())
        context.refresh(sut, mergeChanges: false)
        XCTAssertEqual(sut.currentAmount, 0)
    }

    func testShouldCalculatePositiveQuantity() {
        let sut = Asset(context: context)
        sut.displayName = "Underground Labs X"
        sut.ticker = "UGLX"
        let account = Account(context: context)
        account.name = "Trustworthy"
        let amounts: [Int64] = [5, 15, -2, -10, 30, -20]
        amounts.forEach { amount in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            transaction.amount = amount
        }
        XCTAssertNoThrow(try context.save())
        context.refresh(sut, mergeChanges: false)
        XCTAssertEqual(sut.currentAmount, 18)
    }

    func testShouldCalculateNegativeQuantity() {
        let sut = Asset(context: context)
        sut.displayName = "Bankrupt Brothers"
        sut.ticker = "CLOSED"
        let account = Account(context: context)
        account.name = "Worst Investment Consulting Group"
        let amounts: [Int64] = [100, -200]
        amounts.forEach { amount in
            let transaction = Transaction(context: context)
            transaction.date = Date()
            transaction.account = account
            transaction.asset = sut
            transaction.amount = amount
        }
        XCTAssertNoThrow(try context.save())
        context.refresh(sut, mergeChanges: false)
        XCTAssertEqual(sut.currentAmount, -100)
    }
}
