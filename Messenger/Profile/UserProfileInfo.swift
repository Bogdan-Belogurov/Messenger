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

extension UserDefaults{

    func setUserName(value: String) {
        set(value, forKey: UserProfileInfo.name.rawValue)
    }
    
    func getUserName() -> String {
        return string(forKey: UserProfileInfo.name.rawValue) ?? "Your Name"
    }
    
    func setUserDescription(value: String){
        set(value, forKey: UserProfileInfo.description.rawValue)
    }

    func getUserDescription() -> String{
        return string(forKey: UserProfileInfo.description.rawValue) ?? "Your description"
    }
    
    func setUserImage(image: UIImage) {
        let dataImageJPG = image.jpegData(compressionQuality: 0.75)
        set(dataImageJPG, forKey: UserProfileInfo.image.rawValue)
    }

    func getUserImage() -> UIImage {
        guard let dataImage = data(forKey: UserProfileInfo.image.rawValue) else {
            return UIImage(named: "placeholder-user")!
        }
        if let image = UIImage(data: dataImage) {
            return image
        } else {
            return UIImage(named: "placeholder-user")!
        }
    }
    
}
