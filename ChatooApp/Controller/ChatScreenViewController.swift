//
//  ChatScreenViewController.swift
//  ChatooApp
//
//  Created by hind on 3/19/19.
//  Copyright © 2019 hind. All rights reserved.
//

import UIKit
import Firebase

class ChatScreenViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var ChatTableview: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    var room : Room?
    var chatMessage = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatTableview.delegate = self
        ChatTableview.dataSource = self
        ChatTableview.separatorStyle = .none
        ChatTableview.allowsSelection = false
        title = room?.roomName
        observeMessage()
    }
    
    func getUsernameWithId(id :String , completion: @escaping (_ userName :String?)->()) {
        let databaseref = Database.database().reference()
        let user = databaseref.child("users").child(id)
        
        
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String {
                completion(userName)
            }else{
                completion(nil)
            }
        }
    }
    
    func SendMessgae(text: String , completion: @escaping (_ isSucces:Bool)->()){
        guard let userId = Auth.auth().currentUser?.uid  else{
            return
        }
        let databaseref = Database.database().reference()
        getUsernameWithId(id: userId) { (userName) in
            if let userName = userName {
                if let roomId = self.room?.roomId ,let userId = Auth.auth().currentUser?.uid{
                    
                    let dataArray :[String: Any] = ["senderName": userName, "text": text ,"senderId":userId]
                    let room = databaseref.child("room").child(roomId)
                    room.child("message").childByAutoId().setValue(dataArray,
                                                                   withCompletionBlock: { (error , ref) in
                                                                    if error == nil {
                                                                        completion(true)
                                                                        
                                                                        //   print("Room Added to database Successduly")
                                                                    }else{
                                                                        print(error as Any)
                                                                        completion(false)
                                                                        
                                                                    }
                    })
                    
                }}
        }
        
        
    }
    
    @IBAction func didPressSendButton(_ sender: Any) {
        guard let chatText = self.chatTextField.text , chatText.isEmpty == false else {
            return
        }
        //chack message and return one single value
        SendMessgae(text: chatText) { (isSuccess) in
            if(isSuccess){
                self.chatTextField.text = ""
                
            }
        }
    }
    
    func observeMessage(){
        guard let roomId = self.room?.roomId else {
            return
        }
        let databaseRef = Database.database().reference()
        databaseRef.child("room").child(roomId).child("message").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String:Any] {
                guard let senderName = dataArray["senderName"] as? String , let messageText = dataArray["text"] as? String ,let userId = dataArray["senderId"] as? String else {
                    return
                }
                let  message = Message.init(messagekey: snapshot.key, senderName: senderName, messageText: messageText, userId: userId)
                self.chatMessage.append(message)
                self.ChatTableview.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatMessage[indexPath.row]
        let cell = ChatTableview.dequeueReusableCell(withIdentifier:"ChatCell") as! ChatCell
        cell.SetMessageData(message: message)
        if(message.userId == Auth.auth().currentUser?.uid){
            cell.setBubbleType(type: .outcoming)
        }else{
            cell.setBubbleType(type: .incoming)
        }
        
        return cell
        
    }
    
    
}

