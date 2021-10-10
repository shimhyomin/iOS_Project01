//
//  ChattingManager.swift
//  HyWorld
//
//  Created by shm on 2021/10/10.
//

import Foundation
import Firebase

struct ChattingManager {
    
    let db = Firestore.firestore()
    
    func sendMessage(chatting: Chatting) {
        let sender = chatting.senderUID
        let recipient = chatting.recipientUID
        let message = chatting.message
        
        db.collection("chatting").document(sender).collection(recipient).addDocument(data: ["senderUID": sender, "recipientUID": recipient,"message": message])
        
        db.collection("chatting").document(recipient).collection(sender).addDocument(data: ["senderUID": sender, "recipientUID": recipient,"message": message])
    }
}
