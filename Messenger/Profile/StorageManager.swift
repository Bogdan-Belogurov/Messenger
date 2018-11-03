//
//  StorageManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 02/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import CoreData
import Foundation

class StorageManager: SaveProfileProtocol {
    
    private let coreDataStack: CoreDataStack = CoreDataStack()

    func saveUserProfile(userProfile: UserProfile, completion: @escaping (Bool) -> Void) {
        guard let context = self.coreDataStack.saveContext else { return }

        context.perform {
            let appUserEntity = AppUser.findOrInsertAppUser(in: context)
            appUserEntity?.userName = userProfile.name
            appUserEntity?.userDescription = userProfile.description

            if let picture = userProfile.image {
                appUserEntity?.userImage = picture.jpegData(compressionQuality: 1.0)
            }
            self.coreDataStack.performSave(context: context) {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }

    func loadUserProfile(completion: @escaping (UserProfile?) -> Void) {
        guard let mainContext = coreDataStack.mainContext else { return }
        mainContext.perform {
            guard let profileEntity = AppUser.findOrInsertAppUser(in: mainContext) else {
                completion(nil)
                return
            }
            let profileInfo: UserProfile = UserProfile(name: "Name", description: "About you", image: UIImage(named: "placeholder-user"))
            profileInfo.name = profileEntity.userName
            profileInfo.description = profileEntity.userDescription
            if let picture = profileEntity.userImage {
                profileInfo.image = UIImage(data: picture)
            }
            completion(profileInfo)
        }
    }
}
