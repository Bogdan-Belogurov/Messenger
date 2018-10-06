//
//  MessageCell.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 06/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageBackground: UIView!
    
    var textt: String? {
        didSet {
            self.messageLabel.text = self.textt
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
