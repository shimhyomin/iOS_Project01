//
//  userManager.swift
//  HyWorld
//
//  Created by shm on 2021/10/06.
//

import Foundation
import Firebase

struct UserManager {
    
    func registerUser(user: User) {
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).setData(
            ["uid": user.uid,
             "email": user.email,
             "nickname": user.nickname,
             "profileURL": user.profileURL,
             "discription": user.discription]
        ){ error in
            if let error = error {
                print("Fail to store user info, \(error)")
            } else {
                print("Success to store user info")
            }
        }
    }
}
