//
//  ViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 20/09/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private func logViewController (_ superFunc: String) {
        guard Log().logEnabled else {
            return
        }
        print(superFunc)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logViewController(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewController(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logViewController(#function)
    }
    
    override func viewWillLayoutSubviews() {
        logViewController(#function)
    }
    
    override func viewDidLayoutSubviews() {
        logViewController(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logViewController(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logViewController(#function)
    }

}

