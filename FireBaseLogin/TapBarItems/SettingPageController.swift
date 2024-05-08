//
//  SettingPageController.swift
//  FireBaseLogin
//
//  Created by R91 on 23/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class SettingPageController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var emailAdd: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    
    var userUID1: String = ""
    var userUID = Auth.auth().currentUser?.uid ?? ""
    var temp = 0
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        print("==========\(userUID)==========")
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        Task { @MainActor in
            do {
                try Auth.auth().signOut()
                temp = 0
                alert(title: "DONE!", message: "SignOut Successfully!")
                
            } catch {
                temp = 1
                alert(title: "ERROR!", message: "Something went Wrong!")
            }
        }
        
        func alert(title: String, message: String){
            if temp == 0 {
                let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _  in
                    
                    let navigat = self.storyboard?.instantiateViewController(withIdentifier: "startPageViewController") as! startPageViewController
                    print("true")
                    self.navigationController?.pushViewController(navigat, animated: true)
                }))
                
                present(a, animated: true, completion: {
                    a.view.superview?.isUserInteractionEnabled = true
                    a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
                })
            } else {
                let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(a, animated: true, completion: {
                    a.view.superview?.isUserInteractionEnabled = true
                    a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
                })
            }
        }
    }
    
    @objc func dismissOnTapOut(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigate(){
        _ = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getData() {
        db.collection("Thread").addSnapshotListener { [self]  snapshot, error  in
            if error == nil {
                if let snapshot = snapshot {
                    for i in snapshot.documents {
                        if i.documentID == userUID {
                            if let firstName1 = i.data()["First Name"] as? String,
                               let lastName1 = i.data()["Last Name"] as? String,
                               let email1 = i.data()["Email"] as? String,
                               let mobileNo1 = i.data()["Mobile Number"] as? String {
                                // Update labels with user details
                                self.firstName.text = firstName1
                                self.lastName.text = lastName1
                                self.emailAdd.text = email1
                                self.mobileNo.text = mobileNo1
                                print("1234")
                            }
                        }
                    }
                }
            }
        }
    }
}

//if userUID != userUID {
//    alert(title: "OOPS!", message: "You Can't Selelct Your Self!")
//} else {
//    let a = db.collection("Thread").document()
//                let dic = ["User": [array[indexPath.row].selecteUserUID, userUID, array[indexPath.row].currentUserName], "Thread": a.documentID] as [String : Any]
//                a.setData(dic)
//                hidesBottomBarWhenPushed = true
//                addTableOutLet.reloadData()
//                tabBarController?.selectedIndex = 0
//    }
            
            
            //    var userUID1: String = ""
            //    var userUID = Auth.auth().currentUser?.uid ?? ""
            //    var temp = 0
            //    let db = Firestore.firestore()
            //
            //    override func viewDidLoad() {
            //        super.viewDidLoad()
            //        getdata()
            ////        print("==========\(userUID)==========")
            //    }
            //
            //    @IBAction func logOutBtn(_ sender: Any) {
            //
            //        Task { @MainActor in
            //            do{
            //                try Auth.auth().signOut()
            //                temp = 0
            //
            //                alert(title: "DONE!", message: "SignOut Successfully!")
            //
            //            }
            //            catch{
            //                temp = 1
            //                alert(title: "ERROR!", message: "Something went Wrong!")
            //            }
            //        }
            //
            //        func alert(title: String, message: String){
            //            if temp == 0{
            //                let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            //                a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _  in
            //                    let navigat = self.storyboard?.instantiateViewController(withIdentifier: "startPageViewController") as! startPageViewController
            //                    print("true")
            //                    self.navigationController?.pushViewController(navigat, animated: true)
            //                }))
            //
            //                present(a, animated: true, completion: {
            //                    a.view.superview?.isUserInteractionEnabled = true
            //                    a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
            //                })
            //            }
            //            else{
            //                let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            //                a.addAction(UIAlertAction(title: "OK", style: .cancel))
            //                present(a, animated: true, completion: {
            //                    a.view.superview?.isUserInteractionEnabled = true
            //                    a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOut)))
            //                })
            //            }
            //        }
            //    }
            //    @objc func dismissOnTapOut(){
            //        self.dismiss(animated: true, completion: nil)
            //    }
            //
            //    func navigate(){
            //        _ = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
            //        navigationController?.popToRootViewController(animated: true)
            //    }
            //
            //    func getdata(){
            //          Task { @MainActor in
            //
            //              let snapshot = try await self.db.collection("User").getDocuments()
            //              for i in snapshot.documents {
            //                  if i.documentID == userUID {
            //                      if let firstName1 = i.data()["First Name"] as? String,
            //                         let lastName1 = i.data()["Last Name"] as? String,
            //                         let email1 = i.data()["Email Address"] as? String,
            //                         let mobileNo1 = i.data()["Mobile Number"] as? String {
            //                          // Update labels with user details
            //                          firstName.text = firstName1
            //                          lastName.text = lastName1
            //                          emailAdd.text = email1
            //                          mobileNo.text = mobileNo1
            //                          print("1234")
            //                      }
            //                  }
            //              }
            //          }
            //      }
            
            // gdv154@gmail.com
