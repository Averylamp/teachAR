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

class Image {
    var arImageURL: String
    var description: String
    var height: Double
    var imageID: String
    var links: String
    var targetImageURL: String
    var title: String
    var videoURL: String
    var width: Double
    
    var imageContent: UIImage?
    
    var dictionary: [String: Any]{
        return [
            "ARImageURL": arImageURL,
            "description": description,
            "height": height,
            "imageID": imageID,
            "links": links,
            "targetImageURL":targetImageURL,
            "title":title,
            "videoURL": videoURL,
            "width": width
        ]
    }
    
    func downloadImage(completion: @escaping (Error?)-> ()){
        let url = URL(fileURLWithPath: self.targetImageURL)
        getDataFromUrl(url: url) { (data, response, error) in
            if error != nil {
                completion(error)
            }else{
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data) {
                    self.imageContent = image
                    completion(nil)
                }else{
                    completion(NSError(domain:"", code:455, userInfo:nil))
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    init(arImageURL: String, description: String, height: Double, imageID: String, links: String, targetImageURL:String, title:String, videoURL: String, width:Double) {
        self.arImageURL = arImageURL
        self.description = description
        self.height = height
        self.imageID = imageID
        self.links = links
        self.targetImageURL = targetImageURL
        self.title = title
        self.videoURL = videoURL
        self.width = width
        
    }
    
    convenience init?(dictionary: [String: Any]){
        guard let arImageURL = dictionary["ARImageURL"] as? String,
            let description = dictionary["description"] as? String,
            let height = dictionary["height"] as? Double,
            let imageID = dictionary["imageID"] as? String,
            let links = dictionary["links"] as? String,
            let targetImageURL = dictionary["targetImageURL"] as? String,
            let title = dictionary["title"] as? String,
            let videoURL = dictionary["videoURL"] as? String,
            let width = dictionary["width"] as? Double
            
            else {return nil}
        
        self.init(arImageURL: arImageURL, description: description, height: height, imageID: imageID, links: links, targetImageURL: targetImageURL, title: title, videoURL: videoURL, width: width)
    }
}

