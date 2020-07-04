//
//  ExchangeRateServicePriceOnlyIfAvailableInCurrencyTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Personal on 6/28/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest
@testable import Yawnvestments

//swiftlint:disable:next type_name
class ExchangeRateServicePriceOnlyIfAvailableInCurrencyTests: CoreDataXCTestCase {

    func testShouldReturnEmptyPriceWithoutData() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "Foobar Corporation"
        asset.ticker = "FOO"

        let usd = Currency(context: context)
        usd.displayName = "US Dollar"
        usd.ticker = "USD"
        usd.amountMultiplier = 100

        XCTAssertNoThrow(try context.save())

        let rate = sut.price(of: asset, on: Date.make(2020, 6, 1), onlyIfAvailableIn: usd)
        XCTAssertNil(rate)
    }

    func testShouldReturnEmptyPriceWithOnlyFutureData() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "Bulls and Bears Association"
        asset.ticker = "WAT"

        let pln = Currency(context: context)
        pln.displayName = "Polish złoty"
        pln.ticker = "PLN"
        pln.amountMultiplier = 100

        let rate = ExchangeRate(context: context)
        rate.asset = asset
        rate.currency = pln
        rate.date = Date.make(2192, 11, 22)
        rate.currencyAmount = 217229.0

        XCTAssertNoThrow(try context.save())
        XCTAssertNil(sut.price(of: asset, on: Date.make(2020, 7, 31), onlyIfAvailableIn: pln))
    }

    func testShouldReturnAssetPriceWithSingleRecord() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "BarBaz Global Enterpise Blockhains"
        asset.ticker = "BBEB"

        let eur = Currency(context: context)
        eur.displayName = "Euro"
        eur.ticker = "EUR"
        eur.amountMultiplier = 100

        let rate = ExchangeRate(context: context)
        rate.asset = asset
        rate.currency = eur
        rate.date = Date.make(2019, 12, 31)
        rate.currencyAmount = 4242.0

        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.price(of: asset, on: Date.make(2019, 12, 31), onlyIfAvailableIn: eur), 4242.0)
    }

    func testShouldReturnLatestPriceToDateOfManyRecords() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "LOL Holdings"
        asset.ticker = "LOL"

        let eur = Currency(context: context)
        eur.displayName = "Euro"
        eur.ticker = "EUR"
        eur.amountMultiplier = 100

        let rates: [(Date, Double)] = [
            (Date.make(2020, 4, 1), 10.00),
            (Date.make(2020, 3, 31), 9.91),
            (Date.make(2020, 2, 29), 7.13),
            (Date.make(1997, 11, 11), 49.01),
            (Date.make(2020, 5, 1), 9001.99)
        ]
        rates.forEach {
            let rate = ExchangeRate(context: context)
            rate.asset = asset
            rate.currency = eur
            rate.date = $0.0
            rate.currencyAmount = $0.1
        }

        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.price(of: asset, on: Date.make(2020, 4, 2), onlyIfAvailableIn: eur), 10.00)
    }

    func testShouldIngoreOtherCurrencies() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "legitinvestments"
        asset.ticker = "LEGIT"

        let gbp = Currency(context: context)
        gbp.displayName = "Pound sterling"
        gbp.ticker = "GBP"
        gbp.amountMultiplier = 100

        let rub = Currency(context: context)
        rub.displayName = "Russian Rouble"
        rub.ticker = "RUB"
        rub.amountMultiplier = 100

        let rateGBP = ExchangeRate(context: context)
        rateGBP.asset = asset
        rateGBP.currency = gbp
        rateGBP.date = Date.make(2022, 7, 31)
        rateGBP.currencyAmount = 150.44

        let rateRUB = ExchangeRate(context: context)
        rateRUB.asset = asset
        rateRUB.currency = rub
        rateRUB.date = Date.make(2022, 7, 31)
        rateRUB.currencyAmount = 5932.07

        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.price(of: asset, on: Date.make(2022, 8, 31), onlyIfAvailableIn: gbp), 150.44)
    }

    func testShouldIngoreOtherAssets() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "Legal Trading Commerce 360"
        asset.ticker = "TCT"

        let otherAsset = Asset(context: context)
        otherAsset.displayName = "Kitten and Puppies Corp"
        otherAsset.ticker = "KPC"

        let jpy = Currency(context: context)
        jpy.displayName = "Japanese yen"
        jpy.ticker = "JPY"
        jpy.amountMultiplier = 100

        let rateOfAsset = ExchangeRate(context: context)
        rateOfAsset.asset = asset
        rateOfAsset.currency = jpy
        rateOfAsset.date = Date.make(2020, 3, 27)
        rateOfAsset.currencyAmount = 888_888.88

        let rateOfOtherAsset = ExchangeRate(context: context)
        rateOfOtherAsset.asset = otherAsset
        rateOfOtherAsset.currency = jpy
        rateOfOtherAsset.date = Date.make(2020, 3, 28)
        rateOfOtherAsset.currencyAmount = 333_333.33

        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.price(of: asset, on: Date.make(2020, 3, 29), onlyIfAvailableIn: jpy), 888_888.88)
    }
}
