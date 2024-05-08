//
//  SignUpViewController.swift
//  FireBaseLogin
//
//  Created by R91 on 17/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emialTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        Auth.auth().createUser(withEmail: emialTextField.text ?? "", password: PasswordTextField.text ?? "") { [self] authResult, error in
            if error == nil{
                
                let dictionory = ["First Name": firstNameTextField.text ?? "",
                                  "Last Name": lastNameTextField.text ?? "",
                                  "Mobile Number": mobileNumberTextField.text ?? "",
                                  "Email": emialTextField.text ?? "",
                                  "Password": PasswordTextField.text ?? ""
                ] as [String : Any]
                db.collection("User").document(Auth.auth().currentUser?.uid ?? "").setData(dictionory)
                alert(title: "DONE!", message: "SignUp Successfully!")
                navigate()
                
                //                                Task { @MainActor in
                //                                    let querySnapshot = try await db.collection("User").getDocuments()
                //                                    for document in querySnapshot.documents {
                //                                        print("\(document.documentID) => \(document.data())")
                //                                    }
                //                                }
                //
                //                                let a = self.storyboard?.instantiateViewController(identifier: "UITabBarViewController") as! UITabBarViewController
                //                                self.navigationController?.pushViewController(a, animated: true)
                //                            }
                //                            else{
                //                                self.alert(title: "Oops..!!", message: error?.localizedDescription ?? "")
                //                            }
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
        let a = storyboard?.instantiateViewController(identifier: "UITabBarController") as! UITabBarController
        navigationController?.pushViewController(a, animated: true)
    }
}
