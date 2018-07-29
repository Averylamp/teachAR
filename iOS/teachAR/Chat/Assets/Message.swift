//
//  Message.swift
//  leARn
//
//  Created by Pramoda Karnati on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var name : String!
    var message : String!
}

struct MessageList {
    var messageListId : String!
    var list = [Message]()
}

var chatMessages = Dictionary<String, MessageList>()

var userColor = Dictionary<String, UIColor>()
