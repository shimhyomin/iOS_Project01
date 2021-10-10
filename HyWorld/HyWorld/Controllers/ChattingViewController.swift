//
//  ChattingViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/09.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController {
    
    let chattingManager = ChattingManager()
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let currentUser = Auth.auth().currentUser
    var opponent: User?
    let chattingList: [Chatting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if opponent?.uid == currentUser?.uid {
            navigationItem.title = "나"
        } else {
            navigationItem.title = opponent?.nickname ?? "사용자 알 수 없음"
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let message = messageTextView.text else { return }
        let chatting = Chatting(senderUID: currentUser!.uid, recipientUID: opponent!.uid, message: message)
        chattingManager.sendMessage(chatting: chatting)
    }
}

//MARK: - TableView
extension ChattingViewController {
    
}

//MARK: -UITableViewDelegate
extension ChattingViewController: UITableViewDelegate {
    // send button 누르면 TextView 초기화하기
}
