//
//  Chatting.swift
//  HyWorld
//
//  Created by shm on 2021/10/10.
//

import Foundation

struct Chatting: Codable {
    let senderUID: String
    let recipientUID: String
    let message: String
}
