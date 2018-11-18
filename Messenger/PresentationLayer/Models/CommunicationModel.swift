//
//  CommunicationModel.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class CommunicationModel: CommunicationModelProtocol {
    
    private var communicationManager: CommunicatorManagerDelegate
    
    init(communicationManager: CommunicatorManagerDelegate) {
        self.communicationManager = communicationManager
    }
    
    func sendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> ())?) {
        self.communicationManager.sendMessage(text: text, toUser: toUser, completion: completion)
    }
    
    func start() {
        self.communicationManager.start()
    }
}
