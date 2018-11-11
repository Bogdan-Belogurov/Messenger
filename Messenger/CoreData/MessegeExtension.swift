//
//  MessegeExtention.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 10/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    static func insertMessage(text: String, fromPersonId: String, toPersonId: String, in context:NSManagedObjectContext) -> Message? {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {
            return nil
        }
        message.date = Date()
        message.text = text
        let conversation = Conversation.findOrInsertConversation(withId: fromPersonId, in: context)
        message.conversation = conversation
        return message
    }
    
    static func findMessagesByConversation(withId: String, in context: NSManagedObjectContext) -> [Message]? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print ("Model is not available in context")
            assert(false)
            return nil
        }
        
        var messages: [Message]?
        guard let fetchRequest = Message.fetchRequestMessagesFromConversationId(withId: withId, model: model) else {
            return nil
        }
        
        do {
            messages = try context.fetch(fetchRequest)
        } catch {
            print ("Failed to fetch messages: \(error)")
        }
        
        return messages
    }
    
    static func fetchRequestMessagesFromConversationId(withId:String, model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let templateName = "MessagesFromConversationId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["conversationId" : withId]) as? NSFetchRequest<Message> else {
            assert(false,"No template with name \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}
