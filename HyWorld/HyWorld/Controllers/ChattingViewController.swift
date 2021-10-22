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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    let currentUser = Auth.auth().currentUser
    var opponent: User?
    var opponentUID: String = ""
    let chattingManager = ChattingManager()
    var messageList: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //외부 cell register
        tableView.register(UINib(nibName: "MyChattingCell", bundle: nil), forCellReuseIdentifier: "MyChattingCell")
        tableView.register(UINib(nibName: "YourChattingCell", bundle: nil), forCellReuseIdentifier: "YourChattingCell")
        
        //tableView separator 없애기
        tableView.separatorStyle = .none
        
        //keyboard observer 설정
        //키보드가 올라올 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //키보드가 내려갈 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //!!!해결하기 opponent가 없어서 모두 사용자 알 수 없음으로 뜬다!
        if opponent?.uid == currentUser?.uid {
            navigationItem.title = "나"
        } else {
            navigationItem.title = opponent?.nickname ?? "사용자 알 수 없음"
        }
        
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
        //1:1 chatting만을 고려한다.
        guard let content = messageTextView.text else { return }
        let date = Date().timeIntervalSince1970
        let message = Message(messageID: "", senderUID: currentUser!.uid, content: content, timestamp: date)
        
        chattingManager.sendMessage(opponentUID: opponentUID, message: message)
        messageTextView.text = ""
    }
    
    //TimeInterval을 정해진 DateFormat의 String으로 convert
    private func timeIntervalToDate(timeInterval: TimeInterval) -> String {
        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter
        }()
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}

//MARK: - TableView
extension ChattingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageList[indexPath.row]
        
        if message.senderUID == currentUser?.uid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyChattingCell", for: indexPath) as? MyChattingCell else { return UITableViewCell()}
            cell.myTextLabel.text = message.content
            cell.dateTextLabel.text = self.timeIntervalToDate(timeInterval: message.timestamp)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourChattingCell", for: indexPath) as? YourChattingCell else { return UITableViewCell()}
            cell.yourTextLabel.text = message.content
            cell.dateTextLabel.text = self.timeIntervalToDate(timeInterval: message.timestamp)
            return cell
        }
    }
    
}

extension ChattingViewController: UITableViewDelegate {
    //
}

//MARK: -keyboard
extension ChattingViewController: UITextViewDelegate {
    @objc func keyboardWilShow(noti: Notification) {
        let notiInfo = noti.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.inputViewBottomMargin.constant = height
            //animation할 때 반드시 필요한 코드
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWilHide(noti: Notification) {
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.inputViewBottomMargin.constant = 0
            //animation할 때 반드시 필요한 코드
            self.view.layoutIfNeeded()
        }
    }
}
