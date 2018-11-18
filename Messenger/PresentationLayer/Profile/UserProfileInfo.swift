//
//  UserProfileInfo.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 20/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class UserProfile {
    var name: String?
    var description: String?
    var image: UIImage?
    
    init(name: String?, description: String?, image: UIImage?) {
        self.name = name
        self.description = description
        self.image = image
    }
}

enum UserProfileInfo: String {
    case name
    case description
    case image
}

