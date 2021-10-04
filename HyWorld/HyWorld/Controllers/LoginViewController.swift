//
//  LoginViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/04.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func emailLoginButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                let code = (error as NSError).code
                print("login error code : \(code)")
                print("login error: \(error.localizedDescription)")
            } else {
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController else { return }
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: UIButton) {
        print("googleLoginButtonPressed")
    }
    
    @IBAction func appleLoginButtonPressed(_ sender: UIButton) {
        print("appleLoginButtonPressed")
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        print("resetPasswordButtonPressed")
    }
}
