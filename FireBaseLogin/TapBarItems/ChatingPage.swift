//
//  ChatingPage.swift
//  FireBaseLogin
//
//  Created by R91 on 24/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal

struct ChatData {
    var message: String
    var sender: String
    var time: Date
    var dataType: String
    var imagePath: String
    
    init(dic: QueryDocumentSnapshot) {
        self.message = dic["Message"] as? String ?? "nil msg"
        self.sender = dic["Sender"] as? String ?? "nil msg"
        self.time = (dic["Time"] as! Timestamp).dateValue()
        self.dataType = dic["dataType"] as? String ?? "nil data"
        self.imagePath = dic["imagePath"] as? String ?? "nil imagePath"
    }
}


class ChatingPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var chatTableViewOutlet: UITableView!
    @IBOutlet weak var userImageOutlet: UIImageView!
    @IBOutlet weak var userNameLblOutlet: UILabel!
    
    
    var nameLable = ""
    var userImage = "person.fill"
    var userUID = ""
    var threadUID = ""
    var db = Firestore.firestore()
    var userArray = [ChatData]()
    var uid = Auth.auth().currentUser?.uid
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        userNameLblOutlet.text = nameLable
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        let dic = ["Message": msgTextField.text as Any,
                   "Time": Data(),
                   "Sender": uid as Any,
                   "dataType": "Message",
                   "imagePath": ""]
        
        db.collection("DidSelectUser").document().collection("Chat").addDocument(data: dic) { error in
            if let error = error{
                print("ERROR! \(error.localizedDescription)")
            }
            else
            {
                DispatchQueue.main.async {
                    self.msgTextField.text = ""
                }
            }
        }
    }
    
    func getData(){
        db.collection("Thread").document().collection("Chat").order(by: "Time", descending: false).addSnapshotListener { [self] snapShot, error in
            if error == nil {
                if let snapShot = snapShot {
                    userArray = snapShot.documents.map { i in ChatData(dic: i) }
                    print(userArray)
                    chatTableViewOutlet.reloadData()
                }
            }
            else {
                print("Array Is Emty")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableViewOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        let message = userArray[indexPath.row].message
        
        return cell
    }
}
