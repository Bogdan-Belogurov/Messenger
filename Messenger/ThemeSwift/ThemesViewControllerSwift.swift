//
//  ThemesViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 14/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    let colorThemes = Color()
    var closureTheme: ((UIColor) -> ())?
    //backToPreviousVC

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backToPreviousVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    

}
