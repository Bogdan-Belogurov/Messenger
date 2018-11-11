//
//  UpdateConversationDelegate.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol UpdateConversationAndChatCoreDataDelegate {
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
}

protocol UpdateChatDelegate {
    //CHAT
    func disableSend(withUserID: String)
    func enableSend( withUserID: String)
}
