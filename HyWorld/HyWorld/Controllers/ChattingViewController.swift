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
    let chattingManager = ChattingManager()
    var chattingList: [Message] = []
    
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
        
        //chatting list 가져오기
        /*
        db.collection("chatting").document(currentUser!.uid).collection(opponent!.uid).order(by: "date").addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                print("Fail to retrieving chatting data from Firestore, \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    self.chattingList = documents.compactMap({ doc -> Chatting? in
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                            let chatting = try JSONDecoder().decode(Chatting.self, from: jsonData)
                            return chatting
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
         */
        
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let content = messageTextView.text else { return }
        let date = Date().timeIntervalSince1970
//        let chatting = Chatting(senderUID: currentUser!.uid, recipientUID: opponent!.uid, message: message)
//        chattingManager.sendMessage(chatting: chatting)
        let chattingRoom = ChattingRoom(roomID: opponent!.uid, memebersUID: [currentUser!.uid, opponent!.uid], lastMessage: content, timestamp: date)
        let message = Message(messageID: opponent!.uid, senderUID: currentUser!.uid, content: content, timestamp: date)
        chattingManager.sendMessage(chattingRoom: chattingRoom, message: message)
    }
}

//MARK: - TableView
extension ChattingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatting = chattingList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingCell", for: indexPath)
        //cell.textLabel?.text = chatting.message
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
