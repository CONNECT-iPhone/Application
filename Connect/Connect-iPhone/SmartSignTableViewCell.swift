//
//  SmartSignTableViewCell.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/26/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//

import UIKit

class SmartSignTableViewCell: UITableViewCell {

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(word: String, title: String) {
        self.word.text = word
        self.title.text = title
        self.word.sizeToFit()
        self.title.sizeToFit()
        self.title.numberOfLines = 0
    }

}
