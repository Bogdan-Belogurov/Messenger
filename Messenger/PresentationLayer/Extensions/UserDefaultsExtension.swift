//
//  UserDefaultsExtension.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

extension UserDefaults {
    // MARK: - Themes Extension
    func setColor(color: UIColor?, forKey key: String) {
        
        var colorData: NSData?
        if let color = color {
            do {
                colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
            } catch {
                fatalError("\(error)")
            }
        }
        set(colorData, forKey: key)
    }
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            do {
                color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            } catch {
                fatalError("\(error)")
            }
        }
        return color
    }
    // MARK: - Profile Extension
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
