//
//  AddPageViewController.swift
//  FireBaseLogin
//
//  Created by R91 on 23/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct UserData{
    var currentUserUID: String
    var currentUserName: String
    var selecteUserUID: String
}

class AddPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var array : [UserData] = []
    var selectedUserName: String = ""
    let db = Firestore.firestore()
    var temp = 0
    var uid : String = ""
    var userUID = Auth.auth().currentUser?.uid ?? ""
    
    @IBOutlet weak var addTableOutLet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
    }
    
    func getdata(){
        Task { @MainActor in
            
            let snapshot = try await self.db.collection("User").getDocuments()
            for document in snapshot.documents {
                if let firstName  = document.data()["First Name"] as? String,
                   let lastName = document.data()["Last Name"] as? String{
                    let fullName = "\(firstName) \(lastName)"
                    
                    if userUID == document.documentID{
                        let userData = UserData(currentUserUID: userUID, currentUserName: fullName, selecteUserUID: document.documentID)
                        array.append(userData)
                        addTableOutLet.reloadData()
                        print("Not Append")
                    }
                    else
                    {
                        let userData = UserData(currentUserUID: userUID, currentUserName: fullName, selecteUserUID: document.documentID)
                        array.append(userData)
                        addTableOutLet.reloadData()
                    }
                }
                else{
                    print("Error!")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addTableOutLet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.userNameLbl.text = self.array[indexPath.row].currentUserName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 149
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUserName = array[indexPath.row].currentUserName
        let selectedUserUID = array[indexPath.row].selecteUserUID

        
            guard selectedUserUID != userUID else {
                alert(title: "OOPS!", message: "You Can't Selelct Your Self!")
                return
            }
                let a = db.collection("Thread").document()
                            let dic = ["User": [array[indexPath.row].selecteUserUID, userUID, array[indexPath.row].currentUserName], "Thread": a.documentID] as [String : Any]
                            a.setData(dic)
                            array.remove(at: indexPath.row)
                            addTableOutLet.reloadData()
                            tabBarController?.selectedIndex = 0
            
        }
    
    func alert(title: String, message: String){
        if temp == 0 {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _  in
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
    
    @objc func dismissOnTapOut(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func addDataToFirestore(selectedUserUID: String) {
        let threadDocument = db.collection("Thread").document()
        let data = [
            "User": [selectedUserUID, userUID, selectedUserName],
            "Thread": threadDocument.documentID
        ] as [String : Any]

        threadDocument.setData(data)
        tabBarController?.selectedIndex = 0
    }
}


