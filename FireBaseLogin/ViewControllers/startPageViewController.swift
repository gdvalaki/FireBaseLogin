//
//  startPageViewController.swift
//  FireBaseLogin
//
//  Created by R91 on 19/04/24.
//

import UIKit

class startPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    @IBAction func continueBtn(_ sender: Any) {
        navigate()
    }
    
    func navigate(){
        let a = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        navigationController?.pushViewController(a, animated: true)
    }
    
}
