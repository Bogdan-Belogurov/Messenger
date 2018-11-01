//
//  CoreDataStack.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 31/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {
    // MARK: - NSPersistentStore

    private var storeUrl: URL {
        let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirURL.appendingPathComponent("Store.sqlite")

        return url
    }

    // MARK: - NSManagedObjectModel

    private let managedObjectModelName = "Messenger"

    private var managedObjectModel: NSManagedObjectModel? {
        guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
            print("Empty model URL")
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }

    // MARK: - Coordinator

    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        guard let model = self.managedObjectModel else {
            print("Empty managed Object Model")
            return nil
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeUrl,
                                               options: nil)
        } catch {
            print("Error adding persistent store to coordinator: \(error)")
        }

        return coordinator
    }

    // MARK: - NSManagedObjectContext

    // masterContext
    private var masterContext: NSManagedObjectContext? {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
            print("Empty persistent Store Coordinator")
            return nil
        }
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        context.undoManager = nil

        return context
    }

    // mainContext
    public var mainContext: NSManagedObjectContext? {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        guard let parentContext = self.masterContext else {
            print("No parent master context")
            return nil
        }
        context.parent = parentContext
        context.mergePolicy = NSOverwriteMergePolicy
        context.undoManager = nil

        return context
    }

    // saveContext
    public var saveContext: NSManagedObjectContext? {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        guard let parentContext = self.mainContext else {
            print("No parent main context")
            return nil
        }
        context.parent = parentContext
        context.mergePolicy = NSOverwriteMergePolicy
        context.undoManager = nil

        return context
    }

    func performSave(context: NSManagedObjectContext, completion: @escaping (Error?) -> Void) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                    completion(error)
                }

                if let parent = context.parent {
                    self?.performSave(context: parent, completion: completion)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
