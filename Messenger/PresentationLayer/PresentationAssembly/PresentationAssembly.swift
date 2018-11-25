//
//  PresentationAssembly.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    lazy var themeModel: ThemeModelProtocol = ThemeModel(themeService: self.serviceAssembly.themeService)
    
    lazy var userStorageModel: UserStorageModelProtocol = UserStorageModel(userStorageService: self.serviceAssembly.userStorageManager, userCoreDataStorage: self.serviceAssembly.userStorageManager as! UserStorageManager )
    
    lazy var communicationModel: CommunicationModelProtocol = CommunicationModel(communicationManager: self.serviceAssembly.communicationManager)
    
    lazy var coreDataModel: CoreDataModelProtocol = CoreDataModel(coreDataService: self.serviceAssembly.coreDataService)
    
    lazy var photosModel: IPhotosModel = PhotosModel(imageService: self.serviceAssembly.imagesService)
}
