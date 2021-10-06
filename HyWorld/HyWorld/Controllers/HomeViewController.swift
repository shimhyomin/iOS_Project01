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
        
        db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.homeLabel.text = "\(data)"
            }
    }
    
}
