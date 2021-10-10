//
//  HomeViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/04.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var homeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        /*
         if let error = error {
             print("Fail retrieving data from Firestore, \(error)")
         } else {
             
             if let documents = querySnapshot?.documents {
                 self.friendList = documents.compactMap({ doc -> User? in
                     do {
                         let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                         let user = try JSONDecoder().decode(User.self, from: jsonData)
                         return user
                     } catch let error {
                         print("Fail JSON Parsing, \(error)")
                         return nil
                     }
                 })
                 DispatchQueue.main.async {
                     self.tableView.reloadData()
                 }
             }
         */
        db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                self.homeLabel.text = "No user"
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                self.homeLabel.text = "No user"
                print("Document data was empty.")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                self.homeLabel.text = "\(user.nickname)"
            } catch let error {
                print("Fail JSON Parsing, \(error)")
            }
        }
    }
    
}
