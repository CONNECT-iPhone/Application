//
//  ConversationTableViewCell.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/18/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//

// This class stores the data for each cell in the ConversationTableView
import UIKit

class ConversationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var messageContent: SmartSignLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // initializes the the data in the cell and sets the view frame width the the size of the message.
    func configCell(message: String) {
        self.messageContent.text = message as String
        self.view.frame.size.width = messageContent.frame.size.width + 10
    }
    
}
