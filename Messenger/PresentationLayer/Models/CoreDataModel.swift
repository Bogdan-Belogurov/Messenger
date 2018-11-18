//
//  CoreDataModel.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataModel: CoreDataModelProtocol {
    
    private var coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    var mainContext: NSManagedObjectContext {
        get {return self.coreDataService.mainContext}
    }
    
    func updateConversation(conversationId: String?) {
        guard let conversationId = conversationId else { return }
        let conversation = Conversation.findOrInsertConversation(withId: conversationId, in: self.coreDataService.saveContext)
        conversation?.lastMessage?.isUnread = false
        self.coreDataService.performSave(context: self.coreDataService.saveContext, completionHandler: nil)
    }
}
