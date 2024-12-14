//
//  DoctorTableViewCell.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/9/10.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var tall: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var nationalId: UILabel!
    
    static let identified = "DoctorTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
