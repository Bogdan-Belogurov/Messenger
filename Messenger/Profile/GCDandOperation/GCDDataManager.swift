//
//  GCDDataManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 20/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class GCDDataManager: SaveProfileProtocol {
    
    let saveAndLoadData: SaveAndLoadData = SaveAndLoadData()
    
    func saveUserProfile(userProfile: UserProfile, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let saveData = self.saveAndLoadData.saveData(userProfile: userProfile)
            
            DispatchQueue.main.async {
                completion(saveData)
            }
        }
    }
    
    func loadUserProfile(completion: @escaping (_ profile: UserProfile?) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let loadedData = self.saveAndLoadData.loadData()
            DispatchQueue.main.async {
                completion(loadedData)
            }
        }
    }
}
