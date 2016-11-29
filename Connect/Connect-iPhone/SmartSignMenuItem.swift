//
//  SmartSignMenuItem.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/24/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.
//

import Foundation
import UIKit

class SmartSignMenuItem: UIMenuItem {
    var smartSignText: String
    
    init(title: String, action: Selector, text: String) {
        self.smartSignText = text
        super.init(title: title, action: action)
    }
    
}
