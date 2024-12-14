//
//  UserInfoTableViewCell.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/7/28.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLb: UILabel!
    
    @IBOutlet weak var InfoText: UITextField!
    
    static let identified = "UserInfoTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
