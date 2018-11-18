//
//  CoreDataStack.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 31/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack: CoreDataStackProtocol {
    
    // MARK: - NSPersistentStore
    private var storeUrl: URL {
        let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirURL.appendingPathComponent("Store.sqlite")

        return url
    }

    // MARK: - NSManagedObjectModel
    let managedObjectModelName = "Messenger"

    lazy var managedObjectModel : NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()

    // MARK: - Coordinator
    lazy var persistentStoreCoordinator : NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        
        return coordinator
    }()

    // MARK: - NSManagedObjectContext
    // masterContext
    lazy var masterContext : NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        
        return masterContext
    }()

    // mainContext
    lazy var mainContext : NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        
        return mainContext
    }()

    // saveContext
    lazy var saveContext : NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        
        return saveContext
    }()

    func performSave(context: NSManagedObjectContext, completionHandler: (() -> Void)?) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }

                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            }
        } else {
            completionHandler?()
        }
    }
}
