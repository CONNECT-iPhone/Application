//
//  ConversationTableViewCell.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/18/16.
//  Copyright © 2016 FiveBox. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messageContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(message: String) {
        self.messageContent.text = message
    }
}
