//
//  userManager.swift
//  HyWorld
//
//  Created by shm on 2021/10/06.
//

import Foundation
import Firebase

struct UserManager {
    
    let db = Firestore.firestore()
    
    //!!!path는 constant로 만들어서 관리하기!!!
    
    func registerUser(user: User) {
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
    
    //uid로 firestore의 user 찾기
    func getUser(withUID uid: String) {
        db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                //to do
                return
            }
            guard let data = document.data() else {
                // to do
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)

            } catch let error {
                print("Fail JSON Parsing, \(error)")
            }
        }
    }
}
