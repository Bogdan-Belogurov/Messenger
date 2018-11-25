//
//  CoreAssembly.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class CoreAssembly: CoreAssemblyProtocol {
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack()
    lazy var multipeerCommuncator: Communicator = MultipeerCommunicator()
    lazy var requestSender: IRequestSender = RequestSender()
}
