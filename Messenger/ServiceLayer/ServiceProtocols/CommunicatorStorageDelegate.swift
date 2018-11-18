//
//  UpdateConversationDelegate.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol CommunicatorStorageDelegate {
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func didSendMessage(text: String, fromUser: String, toUser: String)
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
}
