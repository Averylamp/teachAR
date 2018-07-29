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
    @IBOutlet weak var nameLabel: UIView!
    @IBOutlet weak var nameText: UILabel!
    
    func setCellViewWith(message: Message) {
        self.messageTextLabel.text = message.message
        self.nameText.text = message.name
        self.nameLabel.layer.cornerRadius = self.nameLabel.frame.size.width / 2
        self.nameLabel.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.nameText.adjustsFontSizeToFitWidth = true
        self.nameLabel.backgroundColor = userColor[message.name]
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
