//
//  ThemeServiceProtocol.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 17/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

protocol ThemeServiceProtocol {
    
    func setTheme(selectedTheme: UIColor)
    func loadTheme()
}
