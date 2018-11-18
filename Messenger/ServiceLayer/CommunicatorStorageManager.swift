//
//  CommunicatorStorageManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class CommunicatorStorageManager: CommunicatorStorageDelegate {
    
    private var dataStack: CoreDataStackProtocol
    private var communicator: Communicator
    
    init(dataStack: CoreDataStackProtocol, communicator: Communicator) {
        self.dataStack = dataStack
        self.communicator = communicator
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let context = self.dataStack.saveContext
        context.perform {
            let conversation = Conversation.findOrInsertConversation(withId: fromUser, in: context)
            let message = Message.insertMessage(text: text, fromPersonId: fromUser, toPersonId: toUser, in: context)
            message?.isUnread = true
            message?.isInput = true
            conversation?.lastMessage = message
            self.dataStack.performSave(context: context, completionHandler: nil)
        }
    }
    
    func didSendMessage(text: String, fromUser: String, toUser: String) {
        let context = self.dataStack.saveContext
        context.perform {
            let conversation = Conversation.findOrInsertConversation(withId: toUser, in: context)
            let message = Message.insertMessage(text: text, fromPersonId: toUser, toPersonId: fromUser, in: context)
            message?.isUnread = false
            message?.isInput = false
            conversation?.lastMessage = message
            self.dataStack.performSave(context: context, completionHandler: nil)
        }
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let context = self.dataStack.saveContext
        context.perform {
            let user = User.findOrInsertUser(withId: userID, in: context)
            let conversation = Conversation.findOrInsertConversation(withId: userID, in: context)
            user?.conversation = conversation
            user?.name = userName
            user?.isOnline = true
            user?.conversation?.isOnline = true
            self.dataStack.performSave(context: context, completionHandler: nil)
        }
    }
    
    func didLostUser(userID: String) {
        let context = self.dataStack.saveContext
        context.perform {
            let user = User.findOrInsertUser(withId: userID, in: context)
            user?.isOnline = false
            user?.conversation?.isOnline = false
            self.dataStack.performSave(context: context, completionHandler: nil)
        }
    }
}
