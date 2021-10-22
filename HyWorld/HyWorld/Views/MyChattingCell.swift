//
//  MyChattingCell.swift
//  HyWorld
//
//  Created by shm on 2021/10/18.
//

import UIKit

class MyChattingCell: UITableViewCell {

    @IBOutlet weak var myTextLabel: UITextView!
    @IBOutlet weak var dateTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
