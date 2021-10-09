//
//  EmailLoginViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    let db = Firestore.firestore()
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        guard let nickname = nicknameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let passwordConfirm = passwordConfirmTextField.text else { return }
        if password != passwordConfirm { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Fail to Firebase Create User, \(error)")
            } else {
                //createUser 성공
                guard let uid = Auth.auth().currentUser?.uid else { print("Fail to get currentUser's uid"); return }
                let user = User(email: email, nickname: nickname)
                self.userManager.registerUser(withUID: uid, user: user)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
