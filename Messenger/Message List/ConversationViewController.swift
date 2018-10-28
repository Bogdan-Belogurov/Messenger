//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 06/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendMessageButton: UIButton!
    
    var chatData: [Message] = [Message]()
    var conversation: Conversation?
    let listViewController: ConversationsListViewController? = ConversationsListViewController()
    let communicationManager: CommunicationManager? = CommunicationManager()
    var communicator: MultipeerCommunicator?
    var idUserTo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        communicationManager?.chatDelegate = self
        observeKeyboardNotifications()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let message = messageTextField.text {
            if message != "" {
                self.communicationManager?.communicator?.sendMessage(string: message, toUserID: idUserTo!, completionHandler: { (success, error) in
                    if success {
                        self.sendMessageToLocalArray(text: message)
                    } else {
                        print("ERROR sendMessage")
                    }
                })
            }
        }
    }
    
    func sendMessageToLocalArray(text: String) {
        let message = Message(textt: text, isInputMessage: false)
        
        self.chatData.append(message)
        
        self.tableView.reloadData()
        self.messageTextField.text = ""
        
        self.conversation?.currentMessages = self.chatData
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.chatData.count - 1 , section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    

}

    // MARK: -  UITableViewDataSource
extension ConversationViewController:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatData[indexPath.row].isInputMessage {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as? MessageCell else {
                fatalError(#function)
            }
            cell.textt = chatData[indexPath.row].textt
            //cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "outgoing", for: indexPath) as? MessageCell else {
                fatalError(#function)
            }
            cell.textt = chatData[indexPath.row].textt
            //cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        
//        let cell: MessageCell
//        if (indexPath.row % 2) == 0 {
//            cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as! MessageCell
//        } else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "outgoing", for: indexPath) as! MessageCell
//        }
//        cell.textt = "Test Test"

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
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        self.chatData.append(Message(textt: text, isInputMessage: true))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func disableSend(withUserID: String) {
        if self.idUserTo == withUserID {
            DispatchQueue.main.async {
                self.sendMessageButton.isEnabled = false
                self.sendMessageButton.alpha = 0.3
            }
        }
    }
    
    func enableSend(withUserID: String) {
        if self.idUserTo == withUserID {
            DispatchQueue.main.async {
                self.sendMessageButton.isEnabled = true
                self.sendMessageButton.alpha = 1.0
            }
        }
    }
    
    fileprivate func observeKeyboardNotifications()
    {
        let notifier = NotificationCenter.default
        notifier.addObserver(self, selector: #selector(keyboardShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        notifier.addObserver(self, selector: #selector(keyboardHide), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect (x: 0, y: -252, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

