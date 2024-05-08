//
//  MyTableViewCell.swift
//  FireBaseLogin
//
//  Created by R91 on 23/04/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageOutlet: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
