//
//  ResetPasswordController.swift
//  FireBaseLogin
//
//  Created by R91 on 19/04/24.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

class ResetPasswordController: UIViewController {
    
    var userUID = ""
    var temp = 0
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var newPaswdTextFieldOutlet: UITextField!
    @IBOutlet weak var confirmPaswdTextFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userUID)
    }
    @IBAction func svaeBtnAction(_ sender: Any) {
        Task { @MainActor in
            let snapshot = try await self.db.collection("User").getDocuments()
            for document in snapshot.documents {
                print(document.documentID)
                if userUID == document.documentID {
                    
                    if newPaswdTextFieldOutlet.text ?? "" == confirmPaswdTextFieldOutlet.text ?? "" {
                        try await db.collection("User").document(userUID).setData(["Password" : confirmPaswdTextFieldOutlet.text ?? ""])
                        temp = 1
                        resetPaswd()
                        alert(title: "Success!", message: "Password has been Changed Successfully..!!")
                    }
                    else{
                        temp = 0
                        alert(title: "Oops!", message: "Password Not Match Please Check it again!")
                    }
                }
                else{
                    print("False..!!")
                }
            }
        }
    }
    
    func resetPaswd(){
        Auth.auth().currentUser?.updatePassword(to: confirmPaswdTextFieldOutlet.text ?? ""){ error in
            if error == nil{
                print("*** True ***")
            }
            else{
                print("*** False ***")
            }
        }
    }
    
    func alert(title: String, message: String){
        if temp == 0{
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(a, animated: true, completion: {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
            })
        }
        else
        {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [self] alert in
                let navigat = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
              
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
