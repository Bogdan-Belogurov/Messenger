//
//  CommunicationManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationManager: NSObject, CommunicatorDelegate {
    
    var coreDataStorageDelegate: UpdateConversationAndChatCoreDataDelegate?
    var chatDelegate: UpdateChatDelegate?
    var communicator: MultipeerCommunicator?
    
    init(storage: UpdateConversationAndChatCoreDataDelegate) {
        communicator = MultipeerCommunicator()
        self.coreDataStorageDelegate = storage
        super.init()
        self.communicator?.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        print("FoundUser ~> userID: \(userID), user name: \(userName ?? "NONAME")")
        self.coreDataStorageDelegate?.didFoundUser(userID: userID, userName: userName)
        self.chatDelegate?.enableSend(withUserID: userID)
    }
    
    func didLostUser(userID: String) {
        print("Lost User ~> userID: \(userID)")
        self.coreDataStorageDelegate?.didLostUser(userID: userID)
        self.chatDelegate?.disableSend(withUserID: userID)
        
    }
    
    func failedToStartBrowsingforUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.coreDataStorageDelegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    
}
