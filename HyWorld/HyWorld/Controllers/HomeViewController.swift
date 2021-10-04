//
//  HomeViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/04.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var homeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        homeLabel.text = Auth.auth().currentUser?.email ?? ""
    }
    
}
