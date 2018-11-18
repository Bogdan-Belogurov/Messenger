//
//  CommunicationModelProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol CommunicationModelProtocol {
    func sendMessage(text : String, toUser : String, completion: ((Bool, Error?) -> ())?)
    func start()
}
