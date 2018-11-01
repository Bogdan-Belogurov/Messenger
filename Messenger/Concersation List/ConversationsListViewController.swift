//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 05/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ConversationsListViewController: UIViewController {
    //let multipeerCommunicator: MultipeerCommunicator = MultipeerCommunicator()
    var communicationManager: CommunicationManager?
    var onlineConventions = [Conversation]()
    var selectedConversation: Conversation?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToChat" {
            let currentIndexPath = tableView.indexPathForSelectedRow
            let dvc = segue.destination as! ConversationViewController
            dvc.navigationItem.title = onlineConventions[(currentIndexPath?.row)!].name
            dvc.idUserTo = onlineConventions[(currentIndexPath?.row)!].userID
        }

        if segue.identifier == "listToThemes" {
            if let dvc = segue.destination as? ThemesViewController {
                dvc.model = Themes()
                dvc.delegate = self
            }

            if let dvc = segue.destination as? ThemesViewControllerSwift {
                dvc.closureTheme = { themeColorFromVC -> Void in
                    self.view.backgroundColor = themeColorFromVC
                    self.logThemeChanging(selectedTheme: themeColorFromVC)
                }
            }
        }
    }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //multipeerCommunicator.delegate = communicationManager
        communicationManager = CommunicationManager()
        communicationManager?.conversationDelegate = self as UpdateConversationDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    func logThemeChanging(selectedTheme: UIColor) {
        print(#function, selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        UserDefaults.standard.setColor(color: selectedTheme, forKey: "chosenTheme")
    }
}

// MARK: -  UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineConventions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        let conversationWithUser = onlineConventions[indexPath.row]
        cell.name = conversationWithUser.name
        cell.message = conversationWithUser.message
        cell.date = conversationWithUser.date
        cell.online = conversationWithUser.online ?? false
        cell.hasUnreadMessages = conversationWithUser.hasUnreadMessage ?? false
        return cell
    }
}

// MARK: -  UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Online"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationWithUser = onlineConventions[indexPath.row]
        if let conversationId = conversationWithUser.userID {
            if let messages = conversationData[conversationId] {
                conversationWithUser.currentMessages = messages
            }
        }
        selectedConversation = conversationWithUser

        performSegue(withIdentifier: "listToChat", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ThemesViewControllerDelegate

extension ConversationsListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

// MARK: - UpdateConversationDelegate

extension ConversationsListViewController: UpdateConversationDelegate {
    func didAdd(userInfo: Conversation) {
        if let userID = userInfo.userID {
            if let _: Int = self.onlineConventions.index(where: { $0.userID == userID }) {
                return
            } else {
                if let name = userInfo.name {
                    if let userID = userInfo.userID {
                        let user = Conversation(name: name, userID: userID, message: nil, date: Date(), online: true, hasUnreadMessage: false)
                        onlineConventions.append(user)
                    }
                }
            }
        }
        onlineConventions = sortUsersByDateAndName(users: onlineConventions)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didDelete(UserID: String) {
        if let index: Int = self.onlineConventions.index(where: { $0.userID == UserID }) {
            onlineConventions.remove(at: index)
        }

        onlineConventions = sortUsersByDateAndName(users: onlineConventions)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let index: Int = self.onlineConventions.index(where: { $0.userID == fromUser }) {
            onlineConventions[index].message = text
            onlineConventions[index].date = Date()
            onlineConventions[index].hasUnreadMessage = true

            let currentUser = onlineConventions[index]
            if let id = currentUser.userID {
                if let msgs = conversationData[id] {
                    onlineConventions[index].currentMessages = msgs
                }

                onlineConventions[index].currentMessages.append(Message(textt: text, isInputMessage: true))
                conversationData.updateValue(onlineConventions[index].currentMessages, forKey: id)
            }
        }
        onlineConventions = sortUsersByDateAndName(users: onlineConventions)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func sortUsersByDateAndName(users: [Conversation]) -> [Conversation] {
        var tmp = users.filter { $0.date == nil }
        var us = users.filter { $0.date != nil }

        us.sort { (lhs: Conversation, rhs: Conversation) in
            if let _ = lhs.date, let _ = rhs.date {
                return lhs.date! > rhs.date!
            }
            return false
        }

        tmp.sort { (lhs: Conversation, rhs: Conversation) in
            if let _ = lhs.name, let _ = rhs.name {
                return lhs.name! < rhs.name!
            }
            return false
        }
        us.append(contentsOf: tmp)
        return us
    }
}

extension UserDefaults {
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
}
