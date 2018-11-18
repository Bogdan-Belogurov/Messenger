//
//  ServicesAssemblyProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol ServicesAssemblyProtocol {
    var themeService: ThemeServiceProtocol { get }
    var communicationManager: CommunicatorManagerDelegate { get }
    var userStorageManager: SaveProfileProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }
    var communicatorStorageService: CommunicatorStorageDelegate { get }
}
