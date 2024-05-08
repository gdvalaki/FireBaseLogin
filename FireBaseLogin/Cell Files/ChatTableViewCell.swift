//
//  ChatTableViewCell.swift
//  FireBaseLogin
//
//  Created by R91 on 24/04/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var chatImage: UIImageView!
    
    var namelbl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
