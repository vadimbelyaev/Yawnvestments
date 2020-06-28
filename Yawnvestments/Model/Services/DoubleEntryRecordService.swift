//
//  TransactionService.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import Foundation

protocol DoubleEntryRecordServiceType {
    var numberOfRecords: Int { get }
    func record(at index: Int) -> DoubleEntryRecord?
}

final class DoubleEntryRecordService: DoubleEntryRecordServiceType {
    public static var shared = {
        DoubleEntryRecordService(context: AppDelegate.current.persistentContainer.viewContext)
    }()

    private let context: NSManagedObjectContext
    private let fetchResultsController: NSFetchedResultsController<DoubleEntryRecord>

    init(context: NSManagedObjectContext) {
        self.context = context
        let entriesFetchRequest: NSFetchRequest<DoubleEntryRecord> = DoubleEntryRecord.fetchRequest()
        entriesFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DoubleEntryRecord.date, ascending: false)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: entriesFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchResultsController.performFetch()
    }

    var numberOfRecords: Int {
        fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }

    func record(at index: Int) -> DoubleEntryRecord? {
        guard let sectionIndex = fetchResultsController.sections?.startIndex else {
            return nil
        }
        return fetchResultsController.object(at: IndexPath(row: index, section: sectionIndex))
    }
}
