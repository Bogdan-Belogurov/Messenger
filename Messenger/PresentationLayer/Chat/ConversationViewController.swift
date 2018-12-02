//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 06/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConversationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyBoardViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var idUserTo: String?
    var conversationId: String?
    var communicatorModel : CommunicationModelProtocol?
    var fetchedResultsController: NSFetchedResultsController<Message>?
    var messagesManager: MessagesDataManager?
    var emitter: LogoEmitter?

    override func viewDidLoad() {
        super.viewDidLoad()
        emitter = LogoEmitter(superView: self.view)
        AppDelegate.rootAssembly.presentationAssembly.communicationModel.setDelegate(delegate: self)
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.messagesManager = MessagesDataManager(tableView: self.tableView, conversationId: self.conversationId!)
        self.fetchedResultsController = self.messagesManager?.fetchedResultsController
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("fetching error conv")
        }
        addKeyboardObserver()
        self.sendButtonIsEnabled = false
        self.userIsEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.emitter = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let message = messageTextField.text {
            if message != "" {
                self.communicatorModel?.sendMessage(text: message, toUser: self.idUserTo!, completion: { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.messageTextField.text = ""
                            self.sendButtonIsEnabled = false
                        }
                    } else {
                        print("ERROR sendMessage")
                    }
                })
            }
        }
    }
    
    @IBAction func messageTextFieldChanged(_ sender: UITextField) {
        if self.userIsEnabled == true {
            self.sendButtonIsEnabled = sender.text?.isEmpty == false
        }
        
    }
    
    
    var sendButtonIsEnabled: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5, animations: {
                self.sendMessageButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }) { (finish) in
                UIView.animate(withDuration: 0.19, animations: {
                    self.sendMessageButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.sendMessageButton.alpha = self.sendButtonIsEnabled == true ? 1 : 0.5
                    self.sendMessageButton.isEnabled = self.sendButtonIsEnabled
                })
            }
        }
    }
    
    var userIsEnabled: Bool? {
        didSet {
            UIView.animate(withDuration: 1) {
                let scale: CGFloat = self.userIsEnabled == true ? 1.1 : 1
                self.titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.titleLabel.textColor = self.userIsEnabled == true ? #colorLiteral(red: 0.1719075021, green: 0.8975003911, blue: 0.4467943884, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
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

extension ConversationViewController {

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
            keyBoardViewConstraint.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyBoardViewConstraint.constant = 0
        view.layoutIfNeeded()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ConversationViewController: DisplayUserDelegate {
    func didFoundUser(userID: String, userName: String?) {
        self.userIsEnabled = true
    }
    
    func didLostUser(userID: String) {
        self.userIsEnabled = false
    }
}
