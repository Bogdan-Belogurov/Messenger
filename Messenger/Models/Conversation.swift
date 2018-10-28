//
//  Conversation.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 27/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class Conversation: NSObject {
    
    var name: String?
    var userID: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessage: Bool?
    var currentMessages = [Message]()
    
    init(name: String?, userID: String?, message: String?, date: Date?, online: Bool?, hasUnreadMessage: Bool?) {
        self.name = name
        self.userID = userID
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessage = hasUnreadMessage
    }
}
