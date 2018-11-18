//
//  CoreDataModelProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataModelProtocol {
    var mainContext: NSManagedObjectContext { get }
    func updateConversation(conversationId: String?)
}
