//
//  Image.swift
//  leARn
//
//  Created by Avery on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//
import FirebaseFirestore
import Foundation
import Firebase

struct Image {
    var imageID: String
    var description: String
    var title: String
    var height: Double
    var width: Double
    
    var dictionary: [String: Any]{
        return [
            "imageID" : imageID,
            "description": description,
            "title": title,
            "height": height,
            "width": width
        ]
    }
}

extension Image: DocumentSerializable{
    init?(dictionary: [String: Any]){
        guard let imageID = dictionary["iamgeID"] as? String,
            let description = dictionary["name"] as? String,
            let title = dictionary["author"] as? String,
            let height = dictionary["chatID"] as? Double,
            let width = dictionary["expertID"] as? Double
        
            
            else {return nil}
        
        self.init(imageID: imageID, description: description, title: title, height: height, width: width)
    }
}
