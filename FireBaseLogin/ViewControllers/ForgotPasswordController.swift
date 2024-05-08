//
//  ForgotPasswordController.swift
//  FireBaseLogin
//
//  Created by R91 on 19/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    var temp = 0
    let db = Firestore.firestore()
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        Task { @MainActor in
            let querySnapshot = try await db.collection("User").getDocuments()
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
                
                if let email = document.data()["Email"] as? String, email == emailTextFieldOutlet.text {
                    temp = 1
                    alert(title: "Done", message: "Email Validation Is Successfull")
                    userUID =  document.documentID
                    print("TRUE : \(userUID)")
                }
                else {
                    temp = 0
                    alert(title: "Oops!", message: "Invalid Email Please check it!")
                }
            }
        }
    }
    func alert(title: String, message: String){
        if temp == 0{
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "Ok", style: .cancel))
            
            present(a, animated: true, completion: {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
            })
        }
        else{
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [self] alert in
                let navigat = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
                navigat.userUID = userUID
                print("true")
                navigationController?.pushViewController(navigat, animated: true)
            }))
            
            present(a, animated: true) {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
            }
        }
    }
        @objc func dismissOnTapOut(){
        self.dismiss(animated: true, completion: nil)
    }
}



