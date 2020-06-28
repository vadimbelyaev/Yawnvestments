//
//  ExchangeRateServicePriceCalculatedInCurrencyTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Personal on 6/28/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest
@testable import Yawnvestments

//swiftlint:disable:next type_name
class ExchangeRateServicePriceCalculatedInCurrencyTests: CoreDataXCTestCase {

    func testShouldReturnEmptyPriceWithoutData() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "OOP Forever Fund"
        asset.ticker = "OOFF"

        let usd = Currency(context: context)
        usd.displayName = "US Dollar"
        usd.ticker = "USD"

        XCTAssertNoThrow(try context.save())

        let rate = sut.price(of: asset, on: Date.make(2020, 6, 1), calculatedIn: usd)
        XCTAssertNil(rate)
    }

    func testShouldRecalculatePriceToCorrectCurrency() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "La Banque Française Connue"
        asset.ticker = "FRAN"

        let eur = Currency(context: context)
        eur.displayName = "Euro"
        eur.ticker = "EUR"

        let usd = Currency(context: context)
        usd.displayName = "US Dollar"
        usd.ticker = "USD"

        let assetPriceInUSD = ExchangeRate(context: context)
        assetPriceInUSD.asset = asset
        assetPriceInUSD.currency = usd
        assetPriceInUSD.date = Date.make(2020, 8, 1)
        assetPriceInUSD.currencyAmount = 100.0

        let usdToEur = ExchangeRate(context: context)
        usdToEur.asset = usd
        usdToEur.currency = eur
        usdToEur.date = Date.make(2020, 7, 31)
        usdToEur.currencyAmount = 0.96

        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.price(of: asset, on: Date.make(2020, 8, 2), calculatedIn: eur), 96.0)
    }

    func testShouldReturnPriceInTheRequestedCurrencyWhenAvailable() {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "Advanced Crypto Future Services"
        asset.ticker = "FAIL"

        let btc = Currency(context: context)
        btc.displayName = "Bitcoin"
        btc.ticker = "BTC"

        let rate = ExchangeRate(context: context)
        rate.asset = asset
        rate.currency = btc
        rate.date = Date.make(2020, 8, 1)
        rate.currencyAmount = 999.1

        XCTAssertNoThrow(try context.save())
        XCTAssertEqual(sut.price(of: asset, on: Date.make(2020, 8, 2), calculatedIn: btc), 999.1)
    }

    func testShouldReturnNilWhenNoExchangeRatesAvailable() throws {
        let sut = ExchangeRateService(context: context)

        let asset = Asset(context: context)
        asset.displayName = "Hopeless Financial Consulting"
        asset.ticker = "WIN"

        let nok = Currency(context: context)
        nok.displayName = "Norwegian krone"
        nok.ticker = "NOK"

        let cad = Currency(context: context)
        cad.displayName = "Canadian Dollar"
        cad.ticker = "🇨🇦❤️"

        let rate = ExchangeRate(context: context)
        rate.asset = asset
        rate.currency = cad
        rate.date = Date.make(2020, 10, 12)
        rate.currencyAmount = 404

        XCTAssertNoThrow(try context.save())
        XCTAssertNil(sut.price(of: asset, on: Date.make(2020, 10, 20), calculatedIn: nok))
    }

    func testShouldPreferPriceInTheRequestedCurrency() throws {
        try XCTSkipIf(true, """
            TODO: Implement a situation where two prices of the same asset
            are available on the exact same moment and one of them is the
            requested currency. The price in requested currency should be
            preferred to avoid cross-rate calculation.
            """)
    }

    func testShouldPreferPriceInCurrencyWithMoreRecentExchangeRate() throws {
        try XCTSkipIf(true, """
            TODO: Implement a situation where two prices of the same asset
            are available on the exact same moment, but neither of them
            is the requested currency. In this case the currency that has
            a more recent exchange rate available should be used to
            calculate the price in the requested currency.
            """)
    }
}
