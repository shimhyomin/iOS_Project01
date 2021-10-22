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
    
    func sendMessage(opponentUID: String, message: Message) {
        //현재는 1:1 채팅만을 고려한다.
        //chattingRoom.roomID에는 opponent의 uid 값을 가져온다.
        //!!!다시 정리할 필요가 있을 것 같다!!!
        
        guard let currentUser = Auth.auth().currentUser else { return }

        let members = currentUser.uid == opponentUID ? [currentUser.uid] : [currentUser.uid, opponentUID]
        
        for i in 0..<members.count {
             let me = members[i]
            let you = members.reversed()[i]
            let myChattingRoom = db.collection(Constants.DBPath.chattingPath).document(me).collection(Constants.DBPath.chattingRoomPath).document(you)
            myChattingRoom.setData([
                Constants.ChattingRoom.roomIDField: opponentUID,
                Constants.ChattingRoom.membersUIDField: [me, you],
                Constants.ChattingRoom.lastMessageField: message.content,
                Constants.ChattingRoom.timestampField: message.timestamp
            ])
            
            let messageID = myChattingRoom.collection(Constants.DBPath.messagesPath).addDocument(data: [
                Constants.Messages.messageIDField: message.messageID,
                Constants.Messages.senderUIDField: message.senderUID,
                Constants.Messages.contentField: message.content,
                Constants.Messages.timestampField: message.timestamp
            ]).documentID
            
            myChattingRoom.collection(Constants.DBPath.messagesPath).document(messageID).updateData([Constants.Messages.messageIDField: messageID])

        }
        
    }
}
