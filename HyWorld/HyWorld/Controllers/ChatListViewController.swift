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
    var chatList: [ChattingRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chatList 가져오기
        //!!!ChattingManager 함수로 만들기!!! -> protocol로 만들면 되지 않을까??
        db.collection("chatting").document(currentUser!.uid).collection("chattingRoom").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Fail to get ChattingRoom list, \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.chatList = documents.compactMap({ doc -> ChattingRoom? in
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let chattingRoom = try JSONDecoder().decode(ChattingRoom.self, from: jsonData)
                            return chattingRoom
                        } catch let error {
                            print("Fail JSON Parsing, \(error)")
                            return nil
                        }
                    })
                    //???dispatchQueue.main.async 필요한가???
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
}

//MARK: - TableView
extension ChatListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chattingRoom = chatList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath)
        cell.textLabel?.text = chattingRoom.membersUID.last
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //ChattingViewController로 이동
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else { return }
        
        
        viewController.opponentUID = chatList[indexPath.row].membersUID.last!
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
