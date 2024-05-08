//
//  ViewController.swift
//  FireBaseLogin
//
//  Created by R91 on 17/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController {
    
    var credential: AuthCredential?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func forgotPaswdBtn(_ sender: Any) {
        navigat()
    }
    @IBAction func signupBtn(_ sender: Any) {
        navigate()
    }
    
    
    @IBAction func googleSignInBtn(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if error != nil  {
                alert(title: "Oops..!!", message: error?.localizedDescription ?? "")
            }
            else
            {
                let user = result?.user
                let idToken = user?.idToken?.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken ?? "",
                                                               accessToken: user?.accessToken.tokenString ?? "")
                
                Auth.auth().signIn(with: credential) { [self] result, error in
                    if error == nil {
                  
                        alert(title: "Congretulation", message: "Sign in Successfully")
                    } else {
                       
                        alert(title: "Oops..!!", message: error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [self] authResult, error in
            if error == nil{
                let a = self.storyboard?.instantiateViewController(identifier: "UITabBarViewController") as! UITabBarViewController
                self.navigationController?.pushViewController(a, animated: true)
            }
            else{
                self.alert(title: "Oops..!!", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func alert(title: String, message: String){
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(a, animated: true) {
            a.view.superview?.isUserInteractionEnabled = true
            a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
        }
    }
    @objc func dismissOnTapOut(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigate(){
        let a = storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(a, animated: true)
    }
    func navigat(){
        let a = storyboard?.instantiateViewController(identifier: "ForgotPasswordController") as! ForgotPasswordController
        navigationController?.pushViewController(a, animated: true)
    }
}

