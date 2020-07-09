//
//  CoreDataXCTestCase.swift
//  YawnvestmentsTests
//
//  Created by Vadim Belyaev on 6/28/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData
import XCTest
@testable import Yawnvestments

/// Base convenience class for unit tests that use CoreData entities.
/// Initializes a temporary store on disk during `setUp()` and removes it in `tearDown`.
/// The database gets stored on disk rather than in memory because NSInMemoryStoreType is not
/// compatible with derived attributes which are used in the data model of this app.
///
/// Usage:
/// Create a new unit test class.
/// Change its base class from XCTestCase to CoreDataXCTestCase.
/// In a test method access the `context` property to mock CoreData operations.
/// For more advanced testing scenarios like background execution,
/// access `persistentContainer` property.
/// The `persistentContainer` and `context` properties get recreated
/// before the execution of each test method.
class CoreDataXCTestCase: XCTestCase {
    internal var context: NSManagedObjectContext!
    internal var persistentContainer: NSPersistentContainer!

    private var storeDirectory: URL!

    override func setUp() {
        let fileManager = FileManager.default

        // Create a temporary directory for the persistent store
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        storeDirectory = tempDir.appendingPathComponent(UUID().uuidString, isDirectory: true)
        if !fileManager.fileExists(atPath: storeDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: storeDirectory.path, withIntermediateDirectories: true)
            } catch {
                XCTFail("Cound not create a temporary directory: \(error)")
            }
        }

        // Initialize a persistent container
        TestPersistentContainer.customStoreDirectory = storeDirectory
        persistentContainer = TestPersistentContainer(name: "Yawnvestments", managedObjectModel: ManagedObjectModelHolder.managedObjectModel)
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                XCTFail("Failed to create an test persistent container: \(error), \(error.userInfo)")
            }
        })
        context = persistentContainer.viewContext
    }

    override func tearDown() {
        context = nil

        // Remove all persistent stores to safely delete them from disk
        let coordinator = persistentContainer.persistentStoreCoordinator
        coordinator.persistentStores.forEach { store in
            do {
                try coordinator.remove(store)
            } catch {
                print("Failed to remove persistent store \(store): \(error)")
            }
        }
        persistentContainer = nil

        // Remove the sqlite storage from disk
        guard let storeDirectory = storeDirectory else {
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: storeDirectory.path)
        } catch {
            XCTFail("Cleanup failed. Could not remove temporary directory \(storeDirectory.path): \(error)")
        }
    }
}

/// Persistent container that saves the database in an arbitrary location.
/// Keeping the database not in the default location allows unit tests to create a clean DB for each test run,
/// remove the DB from disk after each test and not interfere with the application's database.
/// Set the static `customStoreDirectory` property to the target location before creating
/// any instance of this class.
/// If `customStoreDirectory` is not set, the persistent containter will save the database to the
/// default location and the unit tests can overwrite or corrupt the user data.
private class TestPersistentContainer: NSPersistentContainer {
    static var customStoreDirectory: URL?

    override class func defaultDirectoryURL() -> URL {
        guard let customStoreDirectory = customStoreDirectory else {
            return super.defaultDirectoryURL()
        }
        return customStoreDirectory
    }
}
