//
//  WikipediaKit.swift
//  teachAR
//
//  Created by Pramoda Karnati on 7/29/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WikipediaKit {
    
    static let sharedInstance = WikipediaKit()
    
//     var baseUrl : String = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=Stack%20Overflow"
    var baseUrl : String = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles="
    
    func searchAPI(name: String) -> JSON {
        let searchString : String = baseUrl + name.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        var searchResult : JSON = []
        Alamofire.request(searchString, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                searchResult = json
                
            case .failure(let error):
                print(error)
            }
        }
        return searchResult
    }
    
    func returnArticleFromAPI(name: String) -> Article {
        let searchString : String = baseUrl + name.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        var article = Article()
        
        Alamofire.request(searchString, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print((json["query"]["pages"] as! [ NSDictionary ] )[ 0 ])
                article.title = json["query"]["pages"][0]["title"].rawString([.castNilToNSNull: true])
                article.content = json["query"]["pages"][0]["extract"].rawString([.castNilToNSNull: true])
                
            case .failure(let error):
                print(error)
            }
        }
        print(article)
        return article
    }
    
    func parseInfoIntoArticle(jsonData : JSON) -> Article {
        var article = Article()
        
//        print(jsonData)
//        print(jsonData["query"])
        
        article.title = jsonData["query"]["pages"][0]["title"].rawString([.castNilToNSNull: true])
        article.content = jsonData["query"]["pages"][0]["extract"].rawString([.castNilToNSNull: true])
        
        return article
    }
    
    func getArticle(title : String) -> Article {
        let jData = searchAPI(name: title)
//        print(jData)
        return parseInfoIntoArticle(jsonData: jData)
    }
    
    func getTitleFromArticle(article : Article) -> String {
        return article.title
    }
    
    func getContectFromArticle(article : Article) -> String {
        return article.content
    }
    
}
