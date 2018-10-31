//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 06/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ConversationViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
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
        // self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        communicationManager?.chatDelegate = self
        addKeyboardObserver()
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let message = messageTextField.text {
            if message != "" {
                communicationManager?.communicator?.sendMessage(string: message, toUserID: idUserTo!, completionHandler: { success, _ in
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

        chatData.append(message)

        tableView.reloadData()
        messageTextField.text = ""

        conversation?.currentMessages = chatData

        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.chatData.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

// MARK: -  UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
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
            // cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "outgoing", for: indexPath) as? MessageCell else {
                fatalError(#function)
            }
            cell.textt = chatData[indexPath.row].textt
            // cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
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

// MARK: -  UpdateChatDelegate

extension ConversationViewController: UpdateChatDelegate {
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        chatData.append(Message(textt: text, isInputMessage: true))
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
            view.frame = CGRect(x: view.frame.origin.x,
                                y: -keyboardHeight,
                                width: view.frame.width,
                                height: view.frame.height)
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame = CGRect(x: view.frame.origin.x,
                            y: 0,
                            width: view.frame.width,
                            height: view.frame.height)
        view.layoutIfNeeded()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
