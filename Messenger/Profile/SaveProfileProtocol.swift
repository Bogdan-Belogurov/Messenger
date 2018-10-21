//
//  SaveProfileProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 20/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

protocol SaveProfileProtocol {
    func saveUserProfile(userProfile: UserProfile, completion: @escaping (_ success: Bool) -> ())
    func loadUserProfile(completion: @escaping (_ profile: UserProfile?) -> ())
}
