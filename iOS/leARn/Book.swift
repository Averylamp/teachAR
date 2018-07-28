//
//  Book.swift
//  leARn
//
//  Created by Avery on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Firebase



struct Book {
    var id: String
    var name: String
    var author: String
    var chatID: String
    var expertID: String
    var documentID: String
    
    var dictionary: [String: Any]{
        return [
            "id" : id,
            "name": name,
            "author": author,
            "chatID": chatID,
            "expertID": expertID,
            "documentID": documentID
        ]
    }
}

// A type that can be initialized from a Firestore document.
protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

extension Book: DocumentSerializable{
    init?(dictionary: [String: Any]){
        guard let id = dictionary["id"] as? String,
        let name = dictionary["name"] as? String,
        let author = dictionary["author"] as? String,
        let chatID = dictionary["chatID"] as? String,
        let expertID = dictionary["expertID"] as? String,
        let documentID = dictionary["documentID"] as? String
        
            else {return nil}
        
        self.init(id: id, name: name, author: author, chatID: chatID, expertID: expertID, documentID: documentID)
        
    }
}
