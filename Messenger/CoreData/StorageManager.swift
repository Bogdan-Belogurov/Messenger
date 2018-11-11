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
            
            appUserEntity?.userImage = userProfile.image?.jpegData(compressionQuality: 1.0)
            
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
            let profileInfo: UserProfile = UserProfile(name: "Write your name", description: "Some things about you", image: UIImage(named: "placeholder-user")!)
            //Вопрос
            profileInfo.name = profileEntity.userName
            profileInfo.description = profileEntity.userDescription
            if let picture = profileEntity.userImage {
                profileInfo.image = UIImage(data: picture)
            }
            completion(profileInfo)
        }
    }
}

extension StorageManager: UpdateConversationAndChatCoreDataDelegate {
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        guard let context = self.coreDataStack.saveContext else { return }
        context.perform {
            let conversation = Conversation.findOrInsertConversation(withId: fromUser, in: context)
            let message = Message.insertMessage(text: text, fromPersonId: fromUser, toPersonId: toUser, in: context)
            message?.isUnread = true
            message?.isInput = true
            conversation?.lastMessage = message
            self.coreDataStack.performSave(context: context, completionHandler: nil)
            }
    }
    
    func didSendMessage(text: String, fromUser: String, toUser: String) {
        guard let context = self.coreDataStack.saveContext else { return }
        context.perform {
            let conversation = Conversation.findOrInsertConversation(withId: fromUser, in: context)
            let message = Message.insertMessage(text: text, fromPersonId: fromUser, toPersonId: toUser, in: context)
            message?.isUnread = false
            message?.isInput = false
            conversation?.lastMessage = message
            self.coreDataStack.performSave(context: context, completionHandler: nil)
        }
    }
    
    func didFoundUser(userID: String, userName: String?) {
        guard let context = coreDataStack.saveContext else { return }
        context.perform {
            let user = User.findOrInsertUser(withId: userID, in: context)
            let conversation = Conversation.findOrInsertConversation(withId: userID, in: context)
            user?.conversation = conversation
            user?.name = userName
            user?.isOnline = true
            conversation?.isOnline = true
            self.coreDataStack.performSave(context: context, completionHandler: nil)
        }
        
    }
    
    func didLostUser(userID: String) {
        guard let context = coreDataStack.saveContext else { return }
        let appUserName =  UIDevice.current.identifierForVendor?.uuidString ?? UIDevice.current.name
        
        context.perform {
            let user = User.findOrInsertUser(withId: userID, in: context)
            let conversation = Conversation.findOrInsertConversation(withId: (userID + appUserName), in: context)
            user?.isOnline = false
            conversation?.isOnline = false
            self.coreDataStack.performSave(context: context, completionHandler: nil)
        }
    }
    
    
}
