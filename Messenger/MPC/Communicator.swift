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
    func sendMessage(string: String, toUserID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
