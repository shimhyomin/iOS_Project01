//
//  Chatting.swift
//  HyWorld
//
//  Created by shm on 2021/10/10.
//

import Foundation

//struct Chatting: Codable {
//    let senderUID: String
//    let recipientUID: String
//    let message: String
//}

struct ChattingRoom: Codable {
    let roomID: String
    let memebersUID: [String]
    let lastMessage: String
    let timestamp: TimeInterval
}

struct Message: Codable {
    let messageID: String
    let senderUID: String
    let content: String
    let timestamp: TimeInterval
}
