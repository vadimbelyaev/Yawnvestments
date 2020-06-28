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
}
