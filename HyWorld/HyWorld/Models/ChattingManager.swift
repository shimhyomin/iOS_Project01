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
    
    //!!!path는 constant로 만들어서 관리하기!!!
    
    func sendMessage(chattingRoom: ChattingRoom, message: Message) {
        //현재는 1:1 채팅만을 고려한다.
        //chattingRoom.roomID에는 opponent의 uid 값을 가져온다.
        //!!!다시 정리할 필요가 있을 것 같다!!!
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        for memberUID in chattingRoom.membersUID {
            var roomID = chattingRoom.roomID
            if memberUID != currentUser.uid {
                roomID = currentUser.uid
            }
            
            let chattingRoomRef = db.collection("chatting").document(memberUID).collection("chattingRoom").document(roomID)
            chattingRoomRef.setData([
                "roomID": roomID,
                "membersUID": chattingRoom.membersUID,
                "lastMessage": chattingRoom.lastMessage,
                "timestamp": chattingRoom.timestamp
            ])
            let messageID = chattingRoomRef.collection("messages").addDocument(data: [
                "messageID": "",
                "senderUID": message.senderUID,
                "content": message.content,
                "timestamp": message.timestamp
            ]).documentID
            chattingRoomRef.collection("messages").document(messageID).updateData([
                "messageID": messageID
            ])
        }
    }
}
