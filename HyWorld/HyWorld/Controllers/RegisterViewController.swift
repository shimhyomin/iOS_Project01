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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let nickname = nicknameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordConfirm = passwordConfirmTextField.text ?? ""
        
        if nickname == "" {
            print("nickname empty")
        } else if password != passwordConfirm {
            print("password not confirm")
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("register error \(error)")
                } else {
                    // firestore에 user 정보 저장
                    let uid = Auth.auth().currentUser?.uid ?? ""
                    self.userInit(uid: uid, nickname: nickname)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

//MARK: - Firestore
extension RegisterViewController {
    private func userInit(uid: String, nickname: String) {
        db.collection("users").document(uid).setData(["nickname": nickname]){ error in
            if let error = error {
                print("Fail to store nickname, \(error)")
            } else {
                print("Success to store nickname")
            }
        }
    }
}
