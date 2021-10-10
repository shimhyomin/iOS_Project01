//
//  ChatListViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/10.
//

import UIKit
import Firebase

class ChatListViewController: UITableViewController {
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var chatList: [String] = ["A", "B", "C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chatList 가져오기
        //다음 collection id는 모르는데 어떻게 해야하지? collection 개수나 collection 통째로 못 가져오나?
        
    }
    
}

//MARK: - TableView
extension ChatListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let opponent = chatList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath)
        //cell.textLabel?.text = opponent.nickname
        cell.textLabel?.text = opponent
        return cell
    }
}
