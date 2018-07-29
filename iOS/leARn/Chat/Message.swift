//
//  Message.swift
//  leARn
//
//  Created by Pramoda Karnati on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var name : String!
    var message : String!
}

class MessageList {
    var messageListId : String!
    var messageList = [Message]()
}

var chatMessages = Dictionary<String, MessageList>()

var userColor = Dictionary<String, UIColor>()
