//
//  ChattingViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/09.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController {
    

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let currentUser = Auth.auth().currentUser
    var opponent: User?
    var opponentUID: String = ""
    let chattingManager = ChattingManager()
    var messageList: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if opponent?.uid == currentUser?.uid {
            navigationItem.title = "나"
        } else {
            navigationItem.title = opponent?.nickname ?? "사용자 알 수 없음"
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //message list 가져오기
        db.collection("chatting").document(currentUser!.uid).collection("chattingRoom").document(opponentUID).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Fail to get messages, \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.messageList = documents.compactMap({ doc -> Message? in
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let message = try JSONDecoder().decode(Message.self, from: jsonData)
                            return message
                        } catch let error {
                            print("Fail JSON Parsing, \(error)")
                            return nil
                        }
                    })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let content = messageTextView.text else { return }
        let date = Date().timeIntervalSince1970
        let member = currentUser?.uid == opponent?.uid ? [currentUser!.uid] : [currentUser!.uid, opponentUID]
        
        let chattingRoom = ChattingRoom(roomID: opponentUID, membersUID: member, lastMessage: content, timestamp: date)
        
        let message = Message(messageID: opponentUID, senderUID: currentUser!.uid, content: content, timestamp: date)
        
        chattingManager.sendMessage(chattingRoom: chattingRoom, message: message)
    }
}

//MARK: - TableView
extension ChattingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingCell", for: indexPath)
        cell.textLabel?.text = message.content
        return cell
    }
    
}

extension ChattingViewController: UITableViewDelegate {
    //
}

//MARK: -UITableViewDelegate
extension ChattingViewController: UITextViewDelegate {
    // send button 누르면 TextView 초기화하기
}
