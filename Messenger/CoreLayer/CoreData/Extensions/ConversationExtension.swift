//
//  ConversationExtension.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 10/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    
    static func insertConversation(withId: String, in context : NSManagedObjectContext) -> Conversation? {
        guard let сonversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else {
            return nil
        }
        сonversation.conversationId = withId
        return сonversation
    }
    
    static func findOrInsertConversation(withId: String, in context:NSManagedObjectContext) -> Conversation? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        
        var сonversation : Conversation?
        guard let fetchRequest = Conversation.fetchRequestConversation(withId: withId, model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundConversation = results.first {
                сonversation = foundConversation
            }
        } catch {
            print ("Failed to fetch appUser: \(error)")
        }
        
        if сonversation == nil {
            сonversation = Conversation.insertConversation(withId: withId, in: context)
        }
        return сonversation
    }
    
    
    static func fetchRequestConversation(withId: String, model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["conversationId" : withId]) as? NSFetchRequest<Conversation> else{
            assert(false,"No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
}
