//
//  TransactionService.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 14.01.2020.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation
import CoreData

protocol TransactionServiceType {
    var numberOfTransactions: Int { get }
    func transaction(at index: Int) -> Transaction?
}

class TransactionService: TransactionServiceType {
    public static var shared = {
        return TransactionService(context: AppDelegate.current.persistentContainer.viewContext)
    }()
    
    private let context: NSManagedObjectContext
    private let fetchResultsController: NSFetchedResultsController<Transaction>
    
    init(context: NSManagedObjectContext) {
        self.context = context
        let transactionsFetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        transactionsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: transactionsFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? self.fetchResultsController.performFetch()
    }
    
    var numberOfTransactions: Int {
        fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func transaction(at index: Int) -> Transaction? {
        guard let sectionIndex = fetchResultsController.sections?.startIndex else {
            return nil
        }
        return fetchResultsController.object(at: IndexPath(row: index, section: sectionIndex))
    }
}
