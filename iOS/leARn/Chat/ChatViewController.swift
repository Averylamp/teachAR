//
//  ChatViewController.swift
//  leARn
//
//  Created by Pramoda Karnati on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit
import AgoraSigKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    
    var chatId: String!
    var accountId : String!
    
    var messageList = MessageList()
    
    var userNum = 0 {
        didSet {
            DispatchQueue.main.async(execute: {
                self.title = self.chatId + " (\(String(self.userNum)))"
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logInToAgoraAPI()
        
        self.chatRoomTableView.rowHeight = UITableView.automaticDimension
        self.chatRoomTableView.estimatedRowHeight = 100
        
    }
    
    func logInToAgoraAPI() {
        AgoraSignalKit.Kit.login2(Key.key, account: accountId, token: "_no_need_token", uid: 0, deviceID: nil, retry_time_in_s: 60, retry_count: 5)
        
        // check for new account log in
        let lastAccount = UserDefaults.standard.string(forKey: "accountId")
        if (lastAccount != accountId) {
            UserDefaults.standard.set(accountId, forKey: "accountId")
            chatMessages.removeAll()
        }
        
        if (userColor[accountId] == nil) {
            userColor[accountId] = UIColor.randomColor()
        }
    }
    
    func addAgoraSignalBlock() {
        AgoraSignalKit.Kit.onLog = { (txt) -> () in
            guard var log = txt else {
                return
            }
            let time = log[..<log.index(log.startIndex, offsetBy: 10)]
            let dformatter = DateFormatter()
            let timeInterval = TimeInterval(Int(time)!)
            let date = Date(timeIntervalSince1970: timeInterval)
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            log.replaceSubrange(log.startIndex..<log.index(log.startIndex, offsetBy: 10), with: dformatter.string(from: date) + ".")
            
            LogWriter.write(log: log)
        }
        
        
    }

}
