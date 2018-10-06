//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 05/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private let dateFormatter = DateFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        self.online = false
        self.hasUnreadMessages = false
        super.init(coder: aDecoder)
    }
    
    var name: String? {
        didSet {
            nameLabel.text = self.name
        }
    }
    
    var message: String? {
        didSet {
            if self.message == nil {
                messageLabel.font = UIFont(name: "Helvetica", size: 17)
                messageLabel.text = "No messages yet"
            } else {
                messageLabel.font = UIFont(name: "System", size: 13)
                messageLabel.text = self.message
            }
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = self.date else {
                dateLabel.text = ""
                return
            }
            
            let checkFormat = Calendar.current.compare(Date(), to: date, toGranularity: .day)
            switch checkFormat {
            case .orderedSame:
                dateFormatter.dateFormat = "HH:mm"
                dateLabel.text = dateFormatter.string(from: date)
                break
            default:
                dateFormatter.dateFormat = "dd MMM"
                dateLabel.text = dateFormatter.string(from: date)
                break
            }
        }
    }
    
    var online: Bool {
        didSet {
            if self.online {
                self.backgroundColor = #colorLiteral(red: 1, green: 0.9911487699, blue: 0.9115206599, alpha: 1)
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    var hasUnreadMessages: Bool {
        didSet {
            if self.hasUnreadMessages {
                messageLabel.font = .boldSystemFont(ofSize: 15)
            } else if message != nil {
                messageLabel.font = .systemFont(ofSize: 13)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
