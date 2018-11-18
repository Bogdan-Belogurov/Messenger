//
//  UserStorageModelProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol UserStorageModelProtocol {
    func selectTypeStorage(userStorageType: UserStorageType)
    func saveUser(user: UserProfile, completion: @escaping (_ error : Bool) -> ())
    func loadUser(completion: @escaping (_ user : UserProfile?) -> ())
}

enum UserStorageType {
    case coreData
    case gcdStorage
    case operation
}
