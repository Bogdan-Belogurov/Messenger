//
//  StorageManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 02/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import CoreData
import Foundation

class UserStorageManager: SaveProfileProtocol {
    
    private var coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func saveUserProfile(userProfile: UserProfile, completion: @escaping (Bool) -> Void) {
        let context = self.coreDataStack.saveContext
        context.perform {
            let appUserEntity = AppUser.findOrInsertAppUser(in: context)
            appUserEntity?.userName = userProfile.name
            appUserEntity?.userDescription = userProfile.description
            appUserEntity?.userImage = userProfile.image?.jpegData(compressionQuality: 1.0)
            self.coreDataStack.performSave(context: context) {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    func loadUserProfile(completion: @escaping (UserProfile?) -> Void) {
        let context = self.coreDataStack.saveContext
        context.perform {
            guard let profileEntity = AppUser.findOrInsertAppUser(in: context) else {
                completion(nil)
                return
            }
            let profileInfo: UserProfile = UserProfile(name: "Write your name", description: "Some things about you", image: UIImage(named: "placeholder-user")!)
            profileInfo.name = profileEntity.userName
            profileInfo.description = profileEntity.userDescription
            if let picture = profileEntity.userImage {
                profileInfo.image = UIImage(data: picture)
            }
            DispatchQueue.main.async {
                completion(profileInfo)
            }
        }
    }
}
