//
//  Chatting.swift
//  HyWorld
//
//  Created by shm on 2021/10/10.
//

import Foundation

struct ChattingRoom: Codable {
    let roomID: String
    let membersUID: [String]
    let lastMessage: String
    let timestamp: TimeInterval
}

struct Message: Codable {
    let messageID: String
    let senderUID: String
    let content: String
    let timestamp: TimeInterval
}
