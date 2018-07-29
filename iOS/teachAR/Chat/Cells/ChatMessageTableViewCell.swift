//
//  ChatMessageTableViewCell.swift
//  leARn
//
//  Created by Pramoda Karnati on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit

enum side{
    case left
    case right
}

class ChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
    func setCellViewWith(message: Message) {
        self.messageTextLabel.text = message.message
        self.messageTextLabel.backgroundColor = userColor[message.name]
        self.messageTextLabel.layer.cornerRadius = 8
        
        self.nameText.text = message.name
        self.backgroundColor = UIColor.clear
        self.nameText.adjustsFontSizeToFitWidth = true
    }
}
