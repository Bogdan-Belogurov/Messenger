//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 06/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let testMessage = ["Hi!👋",
                               "Hello dude👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋👋", "How r u?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}

    // MARK: -  UITableViewDataSource
extension ConversationViewController:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2) == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as! MessageCell
            cell.textt = testMessage[indexPath.row]
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outgoing", for: indexPath) as! MessageCell
            cell.textt = testMessage[indexPath.row]
            return cell
        }
    }
}

// MARK: -  UITableViewDelegate
extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
