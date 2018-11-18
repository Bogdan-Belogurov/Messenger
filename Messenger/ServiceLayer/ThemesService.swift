//
//  ThemesService.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class ThemesService: ThemeServiceProtocol {
    
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func setTheme(selectedTheme: UIColor) {
        self.userDefaults.setColor(color: selectedTheme, forKey: "chosenTheme")
    }
    
    func loadTheme() {
        if let currentColor = self.userDefaults.colorForKey(key: "chosenTheme") {
            UINavigationBar.appearance().barTintColor = currentColor
            UINavigationBar.appearance().backgroundColor = currentColor
        }
    }
}
