//
//  CoreDataServiceProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    var mainContext: NSManagedObjectContext {get}
    var saveContext: NSManagedObjectContext {get}
    func performSave(context: NSManagedObjectContext, completionHandler: (()-> Void)?)
}
