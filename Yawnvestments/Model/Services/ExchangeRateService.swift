//
//  ExchangeRateService.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 6/28/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData

protocol ExchangeRateServiceType {
    func price(of asset: Asset, on date: Date, onlyIfAvailableIn currency: Currency) -> Decimal?
}

final class ExchangeRateService: ExchangeRateServiceType {
    public static var shared = {
        ExchangeRateService(context: AppDelegate.current.persistentContainer.viewContext)
    }()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Returns a the price of an asset on a given date in a given currency.
    /// The database must contain at least one record of the asset's price in this very currency.
    /// If there are record of the asset price in other currencies, they are ignored.
    /// - Parameters:
    ///   - asset: Asset to retrieve the price for
    ///   - date: date on which the price should be fetched
    ///   - currency: currency of the price
    /// - Returns: the price of the asset in the currency if there's such data in the database.
    ///   Returns `nil` if there's no price data for this asset in this currency
    ///   on any date prior to the given date.
    public func price(of asset: Asset, on date: Date, onlyIfAvailableIn currency: Currency) -> Decimal? {
        let assetPredicate = NSPredicate(format: "asset == %@", argumentArray: [asset])
        let datePredicate = NSPredicate(format: "date <= %@", argumentArray: [date])
        let currencyPredicate = NSPredicate(format: "currency == %@", argumentArray: [currency])
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [assetPredicate, datePredicate, currencyPredicate])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ExchangeRate.date, ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(fetchRequest)
            return result.first?.currencyAmount.decimalValue
        } catch {
            fatalError("Error fetching exchange rates for asset \(asset.description) on date \(date) in currency \(currency.description): \(error)")
        }
    }

    public func price(of asset: Asset, on date: Date, calculatedIn currency: Currency) -> Decimal? {
        guard let latestPriceInAnyCurrency = priceInAnyCurrency(of: asset, on: date) else {
            return nil
        }

        guard latestPriceInAnyCurrency.currency != currency else {
            return latestPriceInAnyCurrency.currencyAmount.decimalValue
        }

        guard let currencyExchangeRate = price(of: latestPriceInAnyCurrency.currency, on: date, onlyIfAvailableIn: currency) else {
            return nil
        }

        return latestPriceInAnyCurrency.currencyAmount.decimalValue * currencyExchangeRate
    }

    private func priceInAnyCurrency(of asset: Asset, on date: Date) -> ExchangeRate? {
        let assetPredicate = NSPredicate(format: "asset == %@", argumentArray: [asset])
        let datePredicate = NSPredicate(format: "date <= %@", argumentArray: [date])
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [assetPredicate, datePredicate])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ExchangeRate.date, ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            fatalError("Error fetching exchange rates for asset \(asset.description) on date \(date): \(error)")
        }

    }
}
