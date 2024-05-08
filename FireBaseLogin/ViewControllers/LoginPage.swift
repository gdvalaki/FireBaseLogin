//
//  LoginPage.swift
//  FireBaseLogin
//
//  Created by R91 on 17/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginPage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func deleteAccBtn(_ sender: Any) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                self.alert(title: "ERROR", message: error.localizedDescription ?? "")
            } else {
                self.alert(title: "DONE", message: "Account Delete Successfully..!!")
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
}
