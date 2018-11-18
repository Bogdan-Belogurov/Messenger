//
//  ThemesModel.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 18/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class ThemeModel: ThemeModelProtocol {
    
    private var themeService: ThemeServiceProtocol
    
    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
    
    func save(color: UIColor) {
        self.themeService.setTheme(selectedTheme: color)
    }
    
    func loadTheme() {
        self.themeService.loadTheme()
    }
    
}
