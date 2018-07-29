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
    
    @IBOutlet weak var messageContainerView: UIView!
    
    func setCellViewWith(message: Message) {
        self.messageTextLabel.text = message.message
        self.messageContainerView.backgroundColor = Constants.themeColor
        self.messageContainerView.layer.cornerRadius = 14
        
        self.nameText.text = message.name
        self.backgroundColor = UIColor.clear
        self.nameText.adjustsFontSizeToFitWidth = true
    }
}
