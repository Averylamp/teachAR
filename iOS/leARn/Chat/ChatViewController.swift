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
        
        self.chatRoomTableView.rowHeight = UITableView.automaticDimension
        self.chatRoomTableView.estimatedRowHeight = 100
        
        AgoraSignalKit.Kit.channelQueryUserNum(chatId)
        messageList.messageListId = chatId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logInToAgoraAPI()
        addAgoraSignalBlock()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AgoraSignalKit.Kit.channelLeave(chatId)
    }
    
    func logInToAgoraAPI() {
        AgoraSignalKit.Kit.login2(Key.key, account: accountId, token: "_no_need_token", uid: 0, deviceID: nil, retry_time_in_s: 60, retry_count: 5)
        
        // check for new account log in
        let lastAccount = UserDefaults.standard.string(forKey: "myAccount")
        if (lastAccount != accountId) {
            UserDefaults.standard.set(accountId, forKey: "myAccount")
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
        
        // add messages to the account's message list
        AgoraSignalKit.Kit.onMessageInstantReceive = { (accountId, uid, msg) -> () in
            if (chatMessages[accountId!] == nil) {
                let incomingMessage = Message(name: accountId, message: msg)
                var messageList = [Message]()
                messageList.append(incomingMessage)
                chatMessages[accountId!] = MessageList(messageListId: accountId, messageList: messageList)
                return
            }
            let incomingMessage = Message(name: accountId, message: msg)
            chatMessages[accountId!]?.messageList.append(incomingMessage)
        }
        
        AgoraSignalKit.Kit.onMessageChannelReceive = { [weak self] (channelID, account, uid, msg) -> () in
            DispatchQueue.main.async(execute: {
                let message = Message(name: account, message: msg)
                self?.messageList.messageList.append(message)
                self?.updateTableView((self?.channelRoomTableView)!, with: message)
                self?.inputField.text = ""
            })
        }
        
        AgoraSignalKit.Kit.onChannelQueryUserNumResult = { [weak self] (channelID, ecode, num) -> () in
            self?.userNum = Int(num)
        }
        
        AgoraSignalKit.Kit.onChannelUserJoined = { [weak self] (account, uid) -> () in
            self?.userNum += 1
        }
        
        AgoraSignalKit.Kit.onChannelUserLeaved = { [weak self] (account, uid) -> () in
            self?.userNum -= 1
        }
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = inputField.text else { return false }
        
        AgoraSignalKit.Kit.messageChannelSend(chatId, msg: message, msgID: String(messageList.messageList.count))
        
        return true
    }
}

extension ChatViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myAccount = UserDefaults.standard.string(forKey: "myAccount")
        if (messageList.messageList[indexPath.row].name != myAccount) {
            if (userColor[messageList.messageList[indexPath.row].name] == nil) {
                userColor[messageList.messageList[indexPath.row].name] = UIColor.randomColor()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatMessageTableCellLeft", for: indexPath) as! ChatMessageTableViewCell
            cell.setCellViewWith(message: messageList.messageList[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatMessageTableCellRight", for: indexPath) as! ChatMessageTableViewCell
            cell.setCellViewWith(message: messageList.messageList[indexPath.row])
            return cell
        }
    }
}
