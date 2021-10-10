//
//  userModel.swift
//  HyWorld
//
//  Created by shm on 2021/10/05.
//

import Foundation

struct User: Codable {
    var uid: String
    var email: String
    var nickname: String
    var profileURL: String = ""
    var discription: String = ""
}
