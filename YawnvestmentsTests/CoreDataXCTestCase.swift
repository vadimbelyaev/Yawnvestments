//
//  CoreDataXCTestCase.swift
//  YawnvestmentsTests
//
//  Created by Vadim Personal on 6/28/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest

/// Base convenience class for unit tests that use CoreData entities.
/// Initializes an in-memory store during `setUp()`.
/// - Usage:
/// Subclass this class instead of XCTestCase.
/// In a test method access the `context` property to mock CoreData operations.
/// The `context` gets recreated before the execution of each test method.
class CoreDataXCTestCase: XCTestCase {
    internal var context: NSManagedObjectContext!

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
}
