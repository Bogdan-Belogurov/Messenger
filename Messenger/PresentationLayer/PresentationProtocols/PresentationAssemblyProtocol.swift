//
//  PresentationAssemblyProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol PresentationAssemblyProtocol {
    var themeModel: ThemeModelProtocol { get }
    var userStorageModel: UserStorageModelProtocol { get }
    var communicationModel: CommunicationModelProtocol { get }
    var coreDataModel: CoreDataModelProtocol { get }
    var photosModel: IPhotosModel { get }
}
