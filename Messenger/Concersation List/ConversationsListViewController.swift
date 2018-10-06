//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 05/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private struct Conventions {
        var name: String
        var message: String?
        var date: Date
        var online: Bool
        var hasUnreadMessages: Bool
    }
   private let onlineConventions = [Conventions(name: "Bogdan", message: "Hello", date: Date(), online: true, hasUnreadMessages: true),
                                    Conventions(name: "Krutoy", message: "Bye!", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: false),
                                    Conventions(name: "Alex", message: "Go! I've created", date: Date(), online: true, hasUnreadMessages: false),
                                    Conventions(name: "Bob", message: "Call me 😘!", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: true),
                                    Conventions(name: "Liza", message: "Bla bla🤔 Bla blaBla blaBla blaBla blaBla blaBla blaBla blaBla blaBla blaBla blaBla ", date: Date(), online: true, hasUnreadMessages: false),
                                    Conventions(name: "Artem", message: "Go to Ti", date: Date(), online: false, hasUnreadMessages: true),
                                    Conventions(name: "Mom", message: "Are you sleeping?", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: false),
                                    Conventions(name: "Krutoy", message: nil, date: Date(), online: false, hasUnreadMessages: false),
                                    Conventions(name: "Alex", message: nil, date: Date(), online: true, hasUnreadMessages: false),
                                    Conventions(name: "Bob", message: "Call me 😘!", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: true)]
    
    private let historyConventions = [Conventions(name: "Bogdan", message: "Hello", date: Date(), online: false, hasUnreadMessages: true),
                                      Conventions(name: "Krutoy", message: "Bye!", date: Date(), online: false, hasUnreadMessages: false),
                                      Conventions(name: "Alex", message: "Go! I've created", date: Date(), online: false, hasUnreadMessages: false),
                                      Conventions(name: "Bob", message: "Call me 😘!", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: true),
                                      Conventions(name: "Liza", message: "Bla bla🤔", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: false),
                                      Conventions(name: "Artem", message: "Go to Ti", date: Date(), online: false, hasUnreadMessages: true),
                                      Conventions(name: "Mom", message: "Are you sleeping?", date: Date(), online: false, hasUnreadMessages: false),
                                      Conventions(name: "Krutoy", message: "Bye!", date: Date(timeIntervalSinceNow: TimeInterval(arc4random()%9999999)), online: false, hasUnreadMessages: false),
                                      Conventions(name: "Alex", message: "Go! I've created", date: Date(), online: false, hasUnreadMessages: false),
                                      Conventions(name: "Bob", message: "Call me 😘!", date: Date(), online: false, hasUnreadMessages: true)]

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToChat" {
            let currentIndexPath = tableView.indexPathForSelectedRow
            let dvc = segue.destination as! ConversationViewController
            dvc.navigationItem.title = onlineConventions[(currentIndexPath?.row)!].name
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: -  UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConventions.count
        case 1:
            return historyConventions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        if indexPath.section == 0 {
            let online = onlineConventions[indexPath.row]
            cell.name = online.name
            cell.message = online.message
            cell.date = online.date
            cell.online = online.online
            cell.hasUnreadMessages = online.hasUnreadMessages
            
        } else {
            let history = historyConventions[indexPath.row]
            cell.name = history.name
            cell.message = history.message
            cell.date = history.date
            cell.online = history.online
            cell.hasUnreadMessages = history.hasUnreadMessages
        }
        return cell
    }
}

// MARK: -  UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "Error"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToChat", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

