//
//  LoginViewController.swift
//  HyWorld
//
//  Created by shm on 2021/10/04.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func goHome() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController else { return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
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
                self.goHome()
            }
        }
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: UIButton) {
        googleLogin()
    }
    
    @IBAction func appleLoginButtonPressed(_ sender: UIButton) {
        print("appleLoginButtonPressed")
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        print("resetPasswordButtonPressed")
    }
}

//MARK: - GoogleLogin
extension LoginViewController {
    func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
            print("error \(error)")
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            // Google에서 받은 token으로 firebase에 사용자 등록하기
            Auth.auth().signIn(with: credential) { [weak self] _, error in
                guard let self = self else { return }
                            
                if let error = error {
                    print("Fail to Firebase Sign in with Google credential, \(error)")
                } else {
                    self.goHome()
                }
            }

        }
    }
}
