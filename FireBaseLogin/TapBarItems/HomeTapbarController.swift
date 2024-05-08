//
//  HomeTapbarController.swift
//  FireBaseLogin
//
//  Created by R91 on 23/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct ChatThread{
    var UID: [String]
    var threadUID: String
}

class HomeTapbarController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableViewOutlet: UITableView!
    @IBOutlet weak var searchbarOutlet: UISearchBar!
    
    var array = [ChatThread]()
    let db = Firestore.firestore()
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        chatTableViewOutlet.reloadData()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func getData() {
            db.collection("Thread").addSnapshotListener { [self] snapshot, error  in
                if error == nil {
                    if let snapshot = snapshot {
                        array = snapshot.documents.map { i in
                            return ChatThread(UID: i["User"] as? [String] ?? ["nil"], threadUID: i["Thread"] as? String ?? "")
                        }
                        print(array)
                        chatTableViewOutlet.reloadData()
                    }
                }
                print(array)
                chatTableViewOutlet.reloadData()
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return array.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = chatTableViewOutlet.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ChatTableViewCell
            let username = self.array[indexPath.row].UID[2]
            DispatchQueue.main.async {
                cell.nameLable.text = username
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 118
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let a = storyboard?.instantiateViewController(identifier: "ChatingPage") as! ChatingPage
            a.nameLable = array[indexPath.row].UID[2]
            navigationController?.pushViewController(a, animated: true)
        }
        
        func removeChats(forUserID userID: String) {
            array = array.filter { !$0.UID.contains(userID) }
            chatTableViewOutlet.reloadData()
        }
    
        func deleteUserAndChats() {
            Auth.auth().currentUser?.delete { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Error deleting user: \(error.localizedDescription)")
                } else {
                    print("User deleted successfully!")
                    self.removeChats(forUserID: Auth.auth().currentUser?.uid ?? "")
                }
            }
        }

}
