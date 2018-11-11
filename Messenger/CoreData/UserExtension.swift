//
//  UserExtension.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 10/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

extension User {
    static func insertUser(withId: String, in context : NSManagedObjectContext) -> User? {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
            return nil
        }
        user.userId = withId
        return user
    }
    
    static func findOrInsertUser(withId: String, in context:NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        
        var user : User?
        guard let fetchRequest = User.fetchRequestUser(withId: withId, model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Appuser found!")
            if let foundUser = results.first{
                user = foundUser
            }
        } catch {
            print ("Failed to fetch user: \(error)")
        }
        
        if user == nil {
            user = User.insertUser(withId: withId, in: context)
        }
        
        return user
        
    }
    
    static func fetchRequestUser(withId: String, model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "UserId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["userId" : withId]) as? NSFetchRequest<User> else {
            assert(false,"No template with name \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}
