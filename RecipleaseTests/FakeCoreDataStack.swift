//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 02/11/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

class FakeCoreDataStack: CoreDataStack {
    override init() {
        super.init()
    }

    static var testableContext: NSManagedObjectContext = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.newBackgroundContext()
    }()

    static func saveContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

}
