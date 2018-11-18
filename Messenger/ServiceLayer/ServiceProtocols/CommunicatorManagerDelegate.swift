//
//  CommunicatorDelegate.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 27/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol CommunicatorManagerDelegate: class {
    func start()
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingforUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //message
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func sendMessage(text : String, toUser : String, completion: ((Bool, Error?) -> ())?)
}
