//
//  CoreDataService.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService: CoreDataServiceProtocol {
    
    private var coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    var mainContext: NSManagedObjectContext {
        get { return self.coreDataStack.mainContext }
    }
    
    var saveContext: NSManagedObjectContext {
        get { return self.coreDataStack.saveContext }
    }
    
    func performSave(context: NSManagedObjectContext, completionHandler: (()-> Void)?) {
        self.coreDataStack.performSave(context: context, completionHandler: completionHandler)
    }
    
}
