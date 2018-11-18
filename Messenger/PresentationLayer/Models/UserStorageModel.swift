//
//  UserStorageModel.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class UserStorageModel: UserStorageModelProtocol {
    
    private var userStorageService: SaveProfileProtocol
    private var userCoreDataStorage: UserStorageManager
    
    init(userStorageService: SaveProfileProtocol, userCoreDataStorage: UserStorageManager) {
        self.userStorageService = userStorageService
        self.userCoreDataStorage = userCoreDataStorage
    }
    
    func selectTypeStorage(userStorageType: UserStorageType) {
        switch userStorageType {
        case .coreData:
            self.userStorageService = self.userCoreDataStorage
        default:
            self.userStorageService = self.userCoreDataStorage
        }
    }
    
    func saveUser(user: UserProfile, completion: @escaping (Bool) -> ()) {
        self.userStorageService.saveUserProfile(userProfile: user, completion: completion)
    }
    
    func loadUser(completion: @escaping (UserProfile?) -> ()) {
        self.userStorageService.loadUserProfile(completion: completion)
    }
}
