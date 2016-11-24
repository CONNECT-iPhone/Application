//
//  ConversationTableViewCell.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/18/16.
//  Copyright © 2016 FiveBox. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var view: UIView!
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
        self.messageContent.text = message as String
        self.view.frame.size.width = messageContent.frame.size.width + 10
    }
    
//    func roundCorners(field: UIView!, corners: UIRectCorner) {
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: field.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 15, height: 15)).cgPath
//        field.layer.mask = maskLayer
//    }
}
