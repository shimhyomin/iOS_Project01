//
//  EmailLoginViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/04.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
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
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
