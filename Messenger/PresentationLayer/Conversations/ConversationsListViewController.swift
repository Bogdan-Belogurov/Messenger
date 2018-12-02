//
//  ConversationsListViewController.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 05/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class ConversationsListViewController: UIViewController {

    var fetchedResultsController: NSFetchedResultsController<Conversation>?
    var conversationsManager : ConversationsDataManager?
    private var themeService: ThemeModelProtocol = AppDelegate.rootAssembly.presentationAssembly.themeModel

    @IBOutlet weak var tableView: UITableView!

    var emitter: LogoEmitter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        self.conversationsManager = ConversationsDataManager(tableView: self.tableView)
        self.fetchedResultsController = self.conversationsManager?.fetchedResultsController
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("fetching error conv")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.emitter = LogoEmitter(superView: self.view)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.emitter = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToChat" {
            if let currentIndexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! ConversationViewController
                let conversations = self.fetchedResultsController?.object(at: currentIndexPath)
                dvc.navigationItem.title = conversations?.user?.name
                dvc.idUserTo = conversations?.user?.userId
                dvc.conversationId = conversations?.conversationId
                dvc.communicatorModel = AppDelegate.rootAssembly.presentationAssembly.communicationModel
            }
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
}

// MARK: -  UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sectionsCount = self.fetchedResultsController?.sections?.count {
            return sectionsCount
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        let conversations = self.fetchedResultsController?.object(at: indexPath)
        cell.name = conversations?.user?.name
        cell.message = conversations?.lastMessage?.text
        cell.date = conversations?.lastMessage?.date
        cell.online = conversations?.isOnline ?? false
        cell.hasUnreadMessages = conversations?.lastMessage?.isUnread ?? false
        return cell
    }
}

// MARK: -  UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        default:
            return "History"
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

// MARK: - ThemesViewControllerDelegate

extension ConversationsListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        self.logThemeChanging(selectedTheme: selectedTheme)
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print(#function, selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        self.themeService.save(color: selectedTheme)
        self.themeService.loadTheme()
    }
}

