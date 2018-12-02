//
//  CommunicationModel.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol DisplayUserDelegate : class {
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
}

class CommunicationModel: CommunicationModelProtocol {
    
    private weak var delegate: DisplayUserDelegate?
    private var communicationManager: CommunicatorManagerDelegate
    
    init(communicationManager: CommunicatorManagerDelegate) {
        self.communicationManager = communicationManager
        self.communicationManager.delegate = self
        
    }
    
    func sendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> ())?) {
        self.communicationManager.sendMessage(text: text, toUser: toUser, completion: completion)
    }
    
    func start() {
        self.communicationManager.start()
    }
    
    func setDelegate(delegate: DisplayUserDelegate) {
        self.delegate = delegate
    }
}

extension CommunicationModel: UserLostDelegate {
    func didFoundUser(userID: String, userName: String?) {
        self.delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        self.delegate?.didLostUser(userID: userID)
    }
    
    
}
