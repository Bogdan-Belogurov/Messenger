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
    var emitter: LogoEmitter?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emitter = LogoEmitter(superView: self.view)
        view.backgroundColor = UserDefaults.standard.colorForKey(key: "chosenTheme") ?? UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.emitter = nil
    }
    
    @IBAction func themeChangeButton(_ sender: UIButton){
        if let title = sender.titleLabel?.text {
                        switch title{
                        case "White":
                            view.backgroundColor = colorThemes.theme1
                            closureTheme?(colorThemes.theme1)
                        case "Gray":
                            view.backgroundColor = colorThemes.theme2
                            closureTheme?(colorThemes.theme2)
                        case "Green":
                            view.backgroundColor = colorThemes.theme3
                            closureTheme?(colorThemes.theme3)
                        default:
                            return
                        }
                    }
    }
    @IBAction func backToPreviousVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
