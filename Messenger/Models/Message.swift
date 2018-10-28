//
//  Message.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 27/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class Message: NSObject {

    var textt: String?
    var isInputMessage: Bool
    
    init(textt: String?, isInputMessage: Bool) {
        self.textt = textt
        self.isInputMessage = isInputMessage
    }
}

var conversationData: [String:[Message]] = [:]

