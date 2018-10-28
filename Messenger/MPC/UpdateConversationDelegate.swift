//
//  UpdateConversationDelegate.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol UpdateConversationDelegate {
    //Conversation_LIST
    func didAdd(userInfo: Conversation)
    func didDelete(UserID: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

protocol UpdateChatDelegate {
    //CHAT
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func disableSend(withUserID: String)
    func enableSend( withUserID: String)
}
