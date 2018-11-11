//
//  ConversationsDataManager.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 10/11/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation
import CoreData

class MessagesDataManager: NSObject {
    
    let coreDataStack: CoreDataStack = CoreDataStack()
    
    let fetchedResultsController: NSFetchedResultsController<Message>
    let tableView : UITableView
    
    init(tableView: UITableView, conversationId: String) {
        self.tableView = tableView
        
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        
        let predicate = NSPredicate(format: "conversation.conversationId == %@", conversationId)
        fetchRequest.predicate = predicate
        
        let sortByTimestamp = NSSortDescriptor(key: "date",ascending: false)
        fetchRequest.sortDescriptors = [sortByTimestamp]
        
        self.fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: self.coreDataStack.mainContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        self.fetchedResultsController.delegate = self
    }
    
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension MessagesDataManager: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange  anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}

