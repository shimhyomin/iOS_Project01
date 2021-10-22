//
//  Constants.swift
//  HyWorld
//
//  Created by shm on 2021/10/22.
//

import Foundation

struct Constants {
    struct DBPath {
        static let usersPath = "users"
        static let chattingPath = "chatting"
        static let chattingRoomPath = "chattingRoom"
        static let messagesPath = "messages"
    }
    
    struct ChattingRoom {
        static let roomIDField = "roomID"
        static let membersUIDField = "membersUID"
        static let lastMessageField = "lastMessage"
        static let timestampField = "timestamp"
    }
    
    struct Messages {
        static let messageIDField = "messageID"
        static let senderUIDField = "senderUID"
        static let contentField = "content"
        static let timestampField = "timestamp"
    }
    
}
