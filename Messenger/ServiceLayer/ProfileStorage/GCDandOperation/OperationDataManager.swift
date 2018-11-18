//
//  OperationDataManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 21/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

//class OperationDataManager: SaveProfileProtocol {
    
//    let saveAndLoad: SaveAndLoadData = SaveAndLoadData()
//
//    func saveUserProfile(userProfile: UserProfile, completion: @escaping (Bool) -> ()) {
//        let operationQueue = OperationQueue()
//        let saveOperation = SaveOperation(saveAndLoad: self.saveAndLoad, profile: userProfile)
//        saveOperation.qualityOfService = .userInitiated
//        
//        saveOperation.completionBlock = {
//            OperationQueue.main.addOperation {
//                completion(saveOperation.saveSucceeded)
//            }
//        }
//        operationQueue.addOperation(saveOperation)
//        
//    }
//
//    func loadUserProfile(completion: @escaping (UserProfile?) -> ()) {
//        let operationQueue = OperationQueue()
//        let loadOperation = LoadOperation(saveAndLoad: saveAndLoad)
//        loadOperation.qualityOfService = .userInitiated
//        
//        loadOperation.completionBlock = {
//            OperationQueue.main.addOperation {
//                completion(loadOperation.profile)
//            }
//        }
//        operationQueue.addOperation(loadOperation)
//    }
    
//}
