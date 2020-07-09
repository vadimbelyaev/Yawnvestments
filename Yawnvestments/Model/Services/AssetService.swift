//
//  AssetService.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 16.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData

protocol AssetServiceType {
    var numberOfAssets: Int { get }
    func asset(at index: Int) -> Asset?
    func amount(of asset: Asset, on date: Date) -> Int
}

final class AssetService: AssetServiceType {
    public static var shared = {
        AssetService(context: AppDelegate.current.persistentContainer.viewContext)
    }()

    private let context: NSManagedObjectContext
    private let fetchResultsController: NSFetchedResultsController<Asset>

    init(context: NSManagedObjectContext) {
        self.context = context
        let fetchRequest: NSFetchRequest<Asset> = Asset.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Asset.displayName, ascending: true)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchResultsController.performFetch()
    }

    var numberOfAssets: Int {
        fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }

    func asset(at index: Int) -> Asset? {
        guard let sectionIndex = fetchResultsController.sections?.startIndex else {
            return nil
        }
        return fetchResultsController.object(at: IndexPath(row: index, section: sectionIndex))
    }

    /// Amount of asset on a given date.
    /// - Parameters:
    ///   - asset: asset for which the amount needs to be calculated
    ///   - date: date for which the amount needs to be calculated
    /// - Returns: The amount of the asset in fractional units.
    ///
    /// Do not use this method to calculate the current amount of the asset (i.e. amount where the date
    /// is now), use the `currentAmount` property of the `Asset` class instead, it will be much faster.
    func amount(of asset: Asset, on date: Date) -> Int {
        let assetPredicate = NSPredicate(format: "asset == %@", argumentArray: [asset])
        let datePredicate = NSPredicate(format: "date <= %@", argumentArray: [date])
        let amountKeyPathExpression = NSExpression(forKeyPath: \Transaction.amount)
        let sumExpression = NSExpression(forFunction: "sum:", arguments: [amountKeyPathExpression])

        let sumColumnName = "sumOfAmount"

        let expressionDescription = NSExpressionDescription()
        expressionDescription.expression = sumExpression
        expressionDescription.name = sumColumnName
        expressionDescription.expressionResultType = .integer64AttributeType

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Transaction.self))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [assetPredicate, datePredicate])
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        do {
            let result = try context.fetch(fetchRequest)
            guard result.count > 0,
                let resultDict = result[0] as? [String: Int],
                let amount = resultDict[sumColumnName] else {
                fatalError("Error fetching amount of asset \(asset.description) on date \(date): Fetch result returned unexpected data: \(result)")
            }
            return amount
        } catch {
            fatalError("Error fetching amount of asset \(asset.description) on date \(date): \(error)")
        }
    }
}
