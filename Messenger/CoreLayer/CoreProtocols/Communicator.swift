//
//  Communicator.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 27/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol Communicator {
    func start()
    func sendMessage(string: String, toUserID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var delegate: CommunicatorManagerDelegate? { get set }
    var online: Bool { get set }
    var myDisplayName: String {get set}
}
