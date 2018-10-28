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
    
    var currentPeers = [MCPeerID]()
    var conversationDelegate: UpdateConversationDelegate?
    var chatDelegate: UpdateChatDelegate?
    var communicator: MultipeerCommunicator?
    
    override init() {
        super.init()
        communicator = MultipeerCommunicator()
        self.communicator?.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        print("FoundUser ~> userID: \(userID), user name: \(userName ?? "NONAME")")
        let userInfo: Conversation = Conversation(name: userName, userID: userID, message: nil, date: Date(), online: true, hasUnreadMessage: false)
        self.conversationDelegate?.didAdd(userInfo: userInfo)
        self.chatDelegate?.enableSend(withUserID: userID)
    }
    
    func didLostUser(userID: String) {
        print("Lost User ~> userID: \(userID)")
        self.conversationDelegate?.didDelete(UserID: userID)
        self.chatDelegate?.disableSend(withUserID: userID)
        
    }
    
    func failedToStartBrowsingforUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.chatDelegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
        self.conversationDelegate?.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    
}
