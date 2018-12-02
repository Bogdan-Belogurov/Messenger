//
//  CommunicationManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 28/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol UserLostDelegate : class {
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
}

class CommunicationManager: NSObject, CommunicatorManagerDelegate {
    
    var coreDataStorage: CommunicatorStorageDelegate
    var communicator: Communicator
    var delegate: UserLostDelegate?
    
    init(storage: CommunicatorStorageDelegate, communicator: Communicator) {
        self.coreDataStorage = storage
        self.communicator = communicator
        super.init()
        self.communicator.delegate = self
    }
    
    func start() {
        self.communicator.start()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        print("FoundUser ~> userID: \(userID), user name: \(userName ?? "NONAME")")
        self.coreDataStorage.didFoundUser(userID: userID, userName: userName)
        self.delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        print("Lost User ~> userID: \(userID)")
        self.coreDataStorage.didLostUser(userID: userID)
        self.delegate?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingforUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.coreDataStorage.didReceiveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func sendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> ())?) {
        self.coreDataStorage.didSendMessage(text: text, fromUser: self.communicator.myDisplayName, toUser: toUser)
        self.communicator.sendMessage(string: text, toUserID: toUser, completionHandler: completion)
    }
}
