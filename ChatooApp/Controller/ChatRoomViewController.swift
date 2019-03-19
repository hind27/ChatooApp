//
//  ChatRoomViewController.swift
//  ChatooApp
//
//  Created by hind on 3/18/19.
//  Copyright © 2019 hind. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
  

   
    @IBOutlet weak var newRoomTextfelid: UITextField!
    @IBOutlet weak var roomsTable: UITableView!
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.roomsTable.delegate = self
       self.roomsTable.dataSource = self
        
     observeRoom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil)
        {
            self.PresentLoginScreen()
        }
    }
   
    
    @IBAction func didPressLogout(_ sender: Any) {
       try! Auth.auth().signOut()
        PresentLoginScreen()
    }
    
    @IBAction func didPressCreateNewRoom(_ sender: Any){
        //checkTaxtfelid
        guard let roomName = self.newRoomTextfelid.text ,roomName.isEmpty == false else {
            return
        }
        let dataBaseRef = Database.database().reference()
        let room = dataBaseRef.child("rooms").childByAutoId()
        let dataArray:[String:Any] = ["roomName":roomName]
        room.setValue(dataArray){(error , ref ) in
            if(error == nil){
             self.newRoomTextfelid.text = ""
            }
            
        }
    }
    
    func observeRoom() {
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String:Any] {
                if let roomName = dataArray["roomName"] as? String {
                    let room = Room.init(roomName: roomName, roomId: snapshot.key)
                    self.rooms.append(room)
                    self.roomsTable.reloadData()
                }
            }
        }
    }
    
    func PresentLoginScreen()  {
        let chatScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        self.present(chatScreen, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomchat")!
        cell.textLabel?.text = room.roomName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = self.rooms[indexPath.row]
        let chatRoom = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as! ChatScreenViewController
        chatRoom.room = selectedRoom
        self.navigationController?.pushViewController(chatRoom, animated: true)
    }
}
