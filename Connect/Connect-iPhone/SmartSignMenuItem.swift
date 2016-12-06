//
//  SmartSignMenuItem.swift
//  Connect-iPhone
//
//  Created by Youssef Hammoud on 11/24/16.
//  Copyright © 2016 Connect-iPhone. All rights reserved.


//  This class is a subclass of UIMenuItem 
//  that basically adds the the feature of storing the smartSign word in the SmartSignMenuItem object.

import Foundation
import UIKit

class SmartSignMenuItem: UIMenuItem {
    var smartSignText: String
    
    
    init(title: String, action: Selector, text: String) {
        self.smartSignText = text
        super.init(title: title, action: action)
    }
    
}
