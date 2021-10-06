//
//  userManager.swift
//  HyWorld
//
//  Created by shm on 2021/10/06.
//

import Foundation
import Firebase

struct UserManager {
    
    func registerUser(withUID uid: String, nickname: String, profileURL: String = "") {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(["nickname": nickname, "profileURL": profileURL]){ error in
            if let error = error {
                print("Fail to store user info, \(error)")
            } else {
                print("Success to store user info")
            }
        }
    }
}
