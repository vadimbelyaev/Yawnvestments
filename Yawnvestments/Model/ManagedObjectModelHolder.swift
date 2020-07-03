//
//  ManagedObjectModelHolder.swift
//  Yawnvestments
//
//  Created by Vadim Belyaev on 7/3/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import CoreData

/// Holds the merged `NSManagedObjectModel` instance of the bundle.
/// This class facilitates unit testing of the Core Data model to ensure that the managed object model
/// gets loaded only once in the app during the unit tests.
final class ManagedObjectModelHolder {
    private init() {}

    /// One and only instance of the managed object model that should be used to initialize all
    /// `NSPersistentContainer` instances both in the app and in the unit tests.
    static var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: ManagedObjectModelHolder.self)])!
        return managedObjectModel
    }()
}
