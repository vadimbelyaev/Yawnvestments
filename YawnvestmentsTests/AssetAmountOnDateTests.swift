//
//  AssetAmountOnDateTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Belyaev on 7/9/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest
@testable import Yawnvestments

class AssetAmountOnDateTests: CoreDataXCTestCase {
    func testShouldCalculateZeroAmountWithNoTransactions() {
        let asset = Asset(context: context)
        asset.displayName = "Nothing LLC"
        asset.ticker = "NTHG"
        XCTAssertNoThrow(try context.save())

        let sut = AssetService(context: context)
        let amount = sut.amount(of: asset, on: .make(2020, 7, 9))

        XCTAssertEqual(amount, 0)
    }

    func testShouldCalculatePositiveAmount() {
        // Arrange
        let asset = Asset(context: context)
        asset.displayName = "Sometimes Positive"
        asset.ticker = "SPSV"
        let account = Account(context: context)
        account.name = "Flaky Tests Investment Holding"

        let amountsAndDates: [(Int64, Date)] = [
            (1, .make(2019, 1, 1)),
            (1, .make(2019, 1, 2)),
            (2, .make(2019, 1, 4)),
            (3, .make(2019, 1, 8)),
            (5, .make(2019, 1, 16)),
            (8, .make(2019, 1, 20)),
            (13, .make(2019, 1, 31))
        ]
        amountsAndDates.forEach {
            let (amount, date) = $0
            let transaction = Transaction(context: context)
            transaction.date = date
            transaction.account = account
            transaction.asset = asset
            transaction.amount = amount
        }
        XCTAssertNoThrow(try context.save())

        let sut = AssetService(context: context)
        let amount = sut.amount(of: asset, on: .make(2019, 1, 30))

        XCTAssertEqual(amount, 20)
    }
}
