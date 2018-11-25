//
//  ServicesAssembly.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class ServicesAssembly: ServicesAssemblyProtocol {
    
    public let coreAssembly: CoreAssemblyProtocol

    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var themeService: ThemeServiceProtocol = ThemesService(userDefaults: UserDefaults.standard)
    
    lazy var communicatorStorageService: CommunicatorStorageDelegate = CommunicatorStorageManager(dataStack: self.coreAssembly.coreDataStack , communicator: self.coreAssembly.multipeerCommuncator)
    
    lazy var communicationManager: CommunicatorManagerDelegate = CommunicationManager(storage: self.communicatorStorageService, communicator: self.coreAssembly.multipeerCommuncator)
    
    lazy var userStorageManager: SaveProfileProtocol = UserStorageManager(coreDataStack: self.coreAssembly.coreDataStack)
    
    lazy var coreDataService: CoreDataServiceProtocol = CoreDataService(coreDataStack: self.coreAssembly.coreDataStack)
    
    lazy var imagesService: IImagesService = ImagesService(requestSender: self.coreAssembly.requestSender)
}
