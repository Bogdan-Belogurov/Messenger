//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 06/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var keyBoardViewConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendMessageButton: UIButton!

    var chatData: [Message] = [Message]()
    var conversation: Conversation?
    //let listViewController: ConversationsListViewController? = ConversationsListViewController()
    var communicationManager: CommunicationManager?
    var communicator: MultipeerCommunicator?
    var idUserTo: String?
    var conversationId: String? 
    
    var fetchedResultsController: NSFetchedResultsController<Message>?
    var messagesManager: MessagesDataManager?
    //var storageManager: StorageManager? = StorageManager()
//асембли
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        //communicationManager = CommunicationManager()
        //communicationManager?.coreDataStorageDelegate = self.storageManager
        communicationManager?.chatDelegate = self
        self.messagesManager = MessagesDataManager(tableView: self.tableView, conversationId: self.conversationId!)
        self.fetchedResultsController = self.messagesManager?.fetchedResultsController
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("fetching error conv")
        }
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let message = messageTextField.text {
            if message != "" {
                communicationManager?.communicator?.sendMessage(string: message, toUserID: idUserTo!, completionHandler: { success, _ in
                    print(success)
                    if success {
                        //communicationManager?.coreDataStorageDelegate
//                        self.storageManager?.didSendMessage(text: message, fromUser: self.idUserTo!, toUser: UIDevice.current.identifierForVendor?.uuidString ?? UIDevice.current.name)
                        DispatchQueue.main.async {
                            self.messageTextField.text = ""
                        }
                    } else {
                        print("ERROR sendMessage")
                    }
                })
            }
        }
    }

}

// MARK: -  UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = self.fetchedResultsController?.object(at: indexPath) else {
            return UITableViewCell()
        }
        var cell : MessageCell
        if message.isInput {
            cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as! MessageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "outgoing", for: indexPath) as! MessageCell
        }
        
        cell.textt = message.text
        
//        if chatData[indexPath.row].isInputMessage {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as? MessageCell else {
//                fatalError(#function)
//            }
//            cell.textt = chatData[indexPath.row].textt
//            // cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
//            return cell
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "outgoing", for: indexPath) as? MessageCell else {
//                fatalError(#function)
//            }
//            cell.textt = chatData[indexPath.row].textt
//            // cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
}


// MARK: -  UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: -  UpdateChatDelegate

extension ConversationViewController: UpdateChatDelegate {
//    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
//        chatData.append(Message(textt: text, isInputMessage: true))
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                DispatchQueue.main.async {
//                self.scrollToRow()
//                }
//            }
//    }
//
    func scrollToRow() {
        if self.chatData.count != 0 {
            let indexPath = IndexPath(row: self.chatData.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func disableSend(withUserID: String) {
        if idUserTo == withUserID {
            DispatchQueue.main.async {
                self.sendMessageButton.isEnabled = false
                self.sendMessageButton.alpha = 0.3
            }
        }
    }

    func enableSend(withUserID: String) {
        if idUserTo == withUserID {
            DispatchQueue.main.async {
                self.sendMessageButton.isEnabled = true
                self.sendMessageButton.alpha = 1.0
            }
        }
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0,
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.size.height
//            view.frame = CGRect(x: view.frame.origin.x,
//                                y: -keyboardHeight,
//                                width: view.frame.width,
//                                height: view.frame.height)
            //   self.tableViewBottomConstraint.constant = keyboardHeight
            keyBoardViewConstraint.constant = -keyboardHeight
//            DispatchQueue.main.async {
//                self.scrollToRow()
//            }
            

            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        view.frame = CGRect(x: view.frame.origin.x,
//                            y: 0,
//                            width: view.frame.width,
//                            height: view.frame.height)
        // self.tableViewBottomConstraint.constant = 0
        keyBoardViewConstraint.constant = 0
        view.layoutIfNeeded()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
